//
//  MenuBarViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class MenuBarViewModel: ObservableObject {
    @Published var summaryText: String = "Mengukur..."
    @Published var cpuLoad: Double = 0
    @Published var usedRAM: Double = 0
    @Published var totalRAM: Double = 0
    @Published var topProcesses: [ProcessEntity] = []
    @Published var batteryInfo: BatteryInfo?
    @Published var devProcesses: [ProcessEntity] = []
    
    private let systemStatsUseCase: SystemStatsUseCase
    private let getTopProcessesUseCase: GetTopProcessesUseCase
    private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    
    private var timer: AnyCancellable?
    
    init(systemStatsUseCase: SystemStatsUseCase,
         getTopProcessesUseCase: GetTopProcessesUseCase,
         getBatteryInfoUseCase: GetBatteryInfoUseCase) {
        
        self.systemStatsUseCase = systemStatsUseCase
        self.getTopProcessesUseCase = getTopProcessesUseCase
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
    }
    
    func startMonitoring() {
        fetchStats()
        
        timer = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchStats()
            }
    }
    
    func stopMonitoring() {
        timer?.cancel()
        timer = nil
    }
    
    private func fetchStats() {
        do {
            let stats = try systemStatsUseCase.execute()
            
            self.cpuLoad = stats.cpuLoad
            self.usedRAM = stats.usedRAM
            self.totalRAM = stats.totalRAM
            
            let cpuFormatted = String(format: "%.0f%%", stats.cpuLoad)
            let ramUsedFormatted = String(format: "%.1f", stats.usedRAM)
            let ramTotalFormatted = String(format: "%.0f", stats.totalRAM)
            
            self.summaryText = "CPU: \(cpuFormatted) | RAM: \(ramUsedFormatted)/\(ramTotalFormatted)GB"
            
            let allProcesses = (try? getTopProcessesUseCase.execute(limit: 10)) ?? []
            
            self.topProcesses = Array(allProcesses.prefix(3))
            
            let devKeywords = ["ollama", "xcodebuild", "docker", "qemu-system", "java", "node", "python", "swift"]
            self.devProcesses = allProcesses.filter { process in
                devKeywords.contains { keyword in
                    process.name.lowercased().contains(keyword)
                }
            }
            
            if self.devProcesses.count > 2 {
                self.devProcesses = Array(self.devProcesses.prefix(2))
            }
            
            self.batteryInfo = try? getBatteryInfoUseCase.execute()
        } catch {
            self.summaryText = "Error"
        }
    }
}
