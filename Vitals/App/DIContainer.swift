//
//  DIContainer.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class DIContainer: ObservableObject {
    let systemStatsUseCase: SystemStatsUseCase
    let getTopProcessesUseCase: GetTopProcessesUseCase
    let getDeviceInfoUseCase: GetDeviceInfoUseCase
    let getBatteryInfoUseCase: GetBatteryInfoUseCase
    let getNetworkStatsUseCase: GetNetworkStatsUseCase
    let checkFDAUseCase: CheckFDAUseCase
    let scanDeveloperCachesUseCase: ScanDeveloperCachesUseCase
    
    init() {
        let systemStatsRepository = MacSystemStatsRepository()
        self.systemStatsUseCase = SystemStatsUseCaseImpl(repository: systemStatsRepository)
        
        let topProcessesRepository = MacTopProcessesRepository()
        self.getTopProcessesUseCase = GetTopProcessesUseCaseImpl(repository: topProcessesRepository)
        
        let deviceInfoRepository = MacDeviceInfoRepository()
        self.getDeviceInfoUseCase = GetDeviceInfoUseCaseImpl(repository: deviceInfoRepository)
        
        let batteryRepository = MacBatteryRepository()
        self.getBatteryInfoUseCase = GetBatteryInfoUseCaseImpl(repository: batteryRepository)
        
        let networkStatsRepository = MacNetworkRepository()
        self.getNetworkStatsUseCase = GetNetworkStatsUseCaseImpl(repository: networkStatsRepository)
        
        let cacheScannerRepository = MacCacheScannerRepository()
        self.checkFDAUseCase = DefaultCheckFDAUseCase(repository: cacheScannerRepository)
        self.scanDeveloperCachesUseCase = DefaultScanDeveloperCachesUseCase(repository: cacheScannerRepository)
    }
}
