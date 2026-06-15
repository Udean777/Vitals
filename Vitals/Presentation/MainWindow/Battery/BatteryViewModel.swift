//
//  BatteryViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class BatteryViewModel: ObservableObject {
    @Published var batteryInfo: BatteryInfo?
    @Published var errorMessage: String?
    @Published var historyPoints: [BatteryHistoryPoint] = []
    @Published var topEnergyApps: [EnergyAppEntity] = []
    @Published var isFetchingEnergy: Bool = false
    
    private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    nonisolated private let getEnergyAppsUseCase: GetEnergyAppsUseCase
    private let historyRepo = LocalBatteryHistoryRepository()
    private var timer: AnyCancellable?
    
    init(getBatteryInfoUseCase: GetBatteryInfoUseCase, getEnergyAppsUseCase: GetEnergyAppsUseCase) {
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
        self.getEnergyAppsUseCase = getEnergyAppsUseCase
    }
    
    func startMonitoring() {
        fetchData()
        
        timer = Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchData()
            }
    }
    
    func stopMonitoring() {
        timer?.cancel()
    }
    
    private func fetchData() {
        do {
            let info = try? getBatteryInfoUseCase.execute()
            self.batteryInfo = info
            
            if let validInfo = info {
                historyRepo.addPoint(percentage: validInfo.currentPercentage)
                self.historyPoints = historyRepo.getHistory()
            }
        }
        
        guard !isFetchingEnergy else { return }
        isFetchingEnergy = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let apps = self.getEnergyAppsUseCase.execute(limit: 5)
            
            DispatchQueue.main.async {
                if !apps.isEmpty {
                    self.topEnergyApps = apps
                }
                self.isFetchingEnergy = false
            }
        }
    }
}
