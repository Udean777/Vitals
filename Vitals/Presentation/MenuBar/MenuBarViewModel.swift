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
    @Published var topProcesses: [ProcessEntity] = []
    
    private let systemStatsUseCase: SystemStatsUseCase
    private let getTopProcessesUseCase: GetTopProcessesUseCase
    private var timer: AnyCancellable?
    
    init(systemStatsUseCase: SystemStatsUseCase, getTopProcessesUseCase: GetTopProcessesUseCase) {
        self.systemStatsUseCase = systemStatsUseCase
        self.getTopProcessesUseCase = getTopProcessesUseCase
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
            
            let cpuFormatted = String(format: "%.0f%%", stats.cpuLoad)
            let ramUsedFormatted = String(format: "%.1f", stats.usedRAM)
            let ramTotalFormatted = String(format: "%.0f", stats.totalRAM)

            self.summaryText = "CPU: \(cpuFormatted) | RAM: \(ramUsedFormatted)/\(ramTotalFormatted)GB"
            self.topProcesses = (try? getTopProcessesUseCase.execute(limit: 3)) ?? []
        } catch {
            self.summaryText = "Error"
        }
    }
}
