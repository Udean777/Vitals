//
//  OverviewViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published var deviceInfo: DeviceInfo?
    @Published var batteryInfo: BatteryInfo?
    @Published var networkInfo: NetworkStats?
    @Published var systemUsage: SystemUsage?
    
    private let getDeviceInfoUseCase: GetDeviceInfoUseCase
    private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    private let getNetworkStatsUseCase: GetNetworkStatsUseCase
    private let getSystemStatsUseCase: SystemStatsUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(getDeviceInfoUseCase: GetDeviceInfoUseCase,
         getBatteryInfoUseCase: GetBatteryInfoUseCase,
         getNetworkStatsUseCase: GetNetworkStatsUseCase,
         getSystemStatsUseCase: SystemStatsUseCase) {
        
        self.getDeviceInfoUseCase = getDeviceInfoUseCase
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
        self.getNetworkStatsUseCase = getNetworkStatsUseCase
        self.getSystemStatsUseCase = getSystemStatsUseCase
        
        self.deviceInfo = getDeviceInfoUseCase.execute()
    }
    
    func startMonitoring() {
        fetchLiveStats()
        
        Timer.publish(every: 1.0, on: .main, in: .common)
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
        self.batteryInfo = try? getBatteryInfoUseCase.execute()
        self.networkInfo = getNetworkStatsUseCase.execute()
        self.systemUsage = try? getSystemStatsUseCase.execute()
    }
}
