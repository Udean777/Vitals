//
//  OverviewViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine
import WidgetKit

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published var deviceInfo: DeviceInfo?
    @Published var batteryInfo: BatteryInfo?
    @Published var networkInfo: NetworkStats?
    @Published var systemUsage: SystemUsage?
    @Published var topProcesses: [ProcessEntity] = []
    @Published var diskIOStats: DiskIOStats?
    
    private var isFetching = false
    
    private let getDeviceInfoUseCase: GetDeviceInfoUseCase
    private let exportReportUseCase: ExportSystemReportUseCase
    private let killProcessUseCase: KillProcessUseCase
    nonisolated private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    nonisolated private let getNetworkStatsUseCase: GetNetworkStatsUseCase
    nonisolated private let getSystemStatsUseCase: SystemStatsUseCase
    nonisolated private let getTopProcessesUseCase: GetTopProcessesUseCase
    nonisolated private let getDiskIOUseCase: GetDiskIOUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(getDeviceInfoUseCase: GetDeviceInfoUseCase,
         getBatteryInfoUseCase: GetBatteryInfoUseCase,
         getNetworkStatsUseCase: GetNetworkStatsUseCase,
         getSystemStatsUseCase: SystemStatsUseCase,
         getTopProcessesUseCase: GetTopProcessesUseCase,
         exportReportUseCase: ExportSystemReportUseCase,
         killProcessUseCase: KillProcessUseCase,
         getDiskIOUseCase: GetDiskIOUseCase) {
        
        self.getDeviceInfoUseCase = getDeviceInfoUseCase
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
        self.getNetworkStatsUseCase = getNetworkStatsUseCase
        self.getSystemStatsUseCase = getSystemStatsUseCase
        self.getTopProcessesUseCase = getTopProcessesUseCase
        self.exportReportUseCase = exportReportUseCase
        self.killProcessUseCase = killProcessUseCase
        
        self.deviceInfo = getDeviceInfoUseCase.execute()
        self.getDiskIOUseCase = getDiskIOUseCase
    }
    
    func startMonitoring() {
        fetchLiveStats()
        
        let interval = UserDefaults.standard.double(forKey: "refreshIntervalSeconds")
        let safeInterval = interval > 0 ? interval : 1.0
        
        Timer.publish(every: safeInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchLiveStats()
            }
            .store(in: &cancellables)
    }
    
    func stopMonitoring() {
        cancellables.removeAll()
    }
    
    private func fetchLiveStats() {
        guard !isFetching else { return }
        isFetching = true
        
        let diskIO = self.getDiskIOUseCase.execute()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let battery = try? self.getBatteryInfoUseCase.execute()
            let network = self.getNetworkStatsUseCase.execute()
            let system = try? self.getSystemStatsUseCase.execute()
            let processes = try? self.getTopProcessesUseCase.execute(limit: 3)
            
            DispatchQueue.main.async {
                self.batteryInfo = battery
                self.networkInfo = network
                self.systemUsage = system
                self.diskIOStats = diskIO
                
                if let processes = processes, !processes.isEmpty {
                    self.topProcesses = processes
                }
                
                self.isFetching = false
                
                let batteryPct = battery?.currentPercentage ?? 0.0
                let cpuPct = system?.cpuLoad ?? 0.0
                let ramGb = system?.usedRAM ?? 0.0
                
                self.saveDataForWidget(cpu: cpuPct, ram: ramGb, battery: batteryPct)
            }
        }
    }
    
    func exportReport() {
        exportReportUseCase.execute(
            deviceInfo: deviceInfo,
            batteryInfo: batteryInfo,
            systemUsage: systemUsage
        )
    }
    
    func forceQuitProcess(pid: Int) {
        let currentPID = Int(ProcessInfo.processInfo.processIdentifier)
        if pid == currentPID {
            print("Peringatan: Tidak bisa melakukan Force Quit pada Vitals itu sendiri!")
            return
        }
        
        do {
            try killProcessUseCase.execute(pid: pid)
            fetchLiveStats()
        } catch {
            print("Gagal Force Quit proses dengan PID \(pid): \(error.localizedDescription)")
        }
    }
    
    private func saveDataForWidget(cpu: Double, ram: Double, battery: Double) {
        let dict: [String: Double] = [
            "cpu": cpu,
            "ram": ram,
            "battery": battery
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: dict) {
            let fileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".vitals_data.json")
            try? data.write(to: fileURL)
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
