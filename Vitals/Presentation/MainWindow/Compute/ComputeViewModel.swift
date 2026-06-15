//
//  ComputeViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class ComputeViewModel: ObservableObject {
    @Published var cpuLoad: Double = 0
    @Published var usedRAM: Double = 0
    @Published var totalRAM: Double = 16
    @Published var topProcess: [ProcessEntity] = []
    @Published var appMemory: Double = 0
    @Published var wiredMemory: Double = 0
    @Published var compressedMemory: Double = 0
    @Published var cachedFiles: Double = 0
    @Published var swapUsed: Double = 0.0
    @Published var thermalState: String = "Normal"
    @Published var memoryPressure: MemoryPressureLevel = .normal
    
    private let systemStatsUseCase: SystemStatsUseCase
    private let getTopProcessesUseCase: GetTopProcessesUseCase
    private var timer: AnyCancellable?
    
    init(systemStatsUseCase: SystemStatsUseCase, getTopProcessesUseCase: GetTopProcessesUseCase) {
        self.systemStatsUseCase = systemStatsUseCase
        self.getTopProcessesUseCase = getTopProcessesUseCase
        self.memoryPressure = memoryPressure
    }
    
    func startMonitoring() {
        fetchData()
        
        timer = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.fetchData() }
    }
    
    func stopMonitoring() {
        timer?.cancel()
    }
    
    private func fetchData() {
        if let stats = try? systemStatsUseCase.execute() {
            self.cpuLoad = stats.cpuLoad
            self.usedRAM = stats.usedRAM
            self.totalRAM = stats.totalRAM
            self.appMemory = stats.appMemory
            self.wiredMemory = stats.wiredMemory
            self.compressedMemory = stats.compressedMemory
            self.cachedFiles = stats.cachedFiles
            self.swapUsed = stats.swapUsed
            self.thermalState = stats.thermalState
        }
        
        self.topProcess = (try? getTopProcessesUseCase.execute(limit: 10)) ?? []
    }
}
