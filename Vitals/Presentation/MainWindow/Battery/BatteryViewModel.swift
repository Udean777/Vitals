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
    
    private let getBatteryInfoUseCase: GetBatteryInfoUseCase
    private var timer: AnyCancellable?
    
    init(getBatteryInfoUseCase: GetBatteryInfoUseCase) {
        self.getBatteryInfoUseCase = getBatteryInfoUseCase
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
            self.batteryInfo = try getBatteryInfoUseCase.execute()
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Gagal mengambil data baterai."
        }
    }
}
