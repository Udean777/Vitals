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
    
    private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    private let historyRepo = LocalBatteryHistoryRepository()
    private var timer: AnyCancellable?
    
    init(getBatteryInfoUseCase: GetBatteryInfoUseCase) {
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
        historyRepo.generateMockDataIfNeeded()
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
    }
}
