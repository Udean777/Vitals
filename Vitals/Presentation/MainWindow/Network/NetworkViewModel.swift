//
//  NetworkViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class NetworkViewModel: ObservableObject {
    @Published var networkStats: NetworkStats?
    @Published var downloadSpeedString: String = "0 KB/s"
    @Published var uploadSpeedString: String = "0 KB/s"
    @Published var totalDownloadedString: String = "0 GB"
    @Published var totalUploadedString: String = "0 GB"
    
    private let getNetworkStatsUseCase: GetNetworkStatsUseCase
    private var timer: AnyCancellable?
    
    init(getNetworkStatsUseCase: GetNetworkStatsUseCase) {
        self.getNetworkStatsUseCase = getNetworkStatsUseCase
    }
    
    func startMonitoring() {
        _ = getNetworkStatsUseCase.execute()
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.fetchData() }
    }
    
    func stopMonitoring() {
        timer?.cancel()
    }
    
    private func fetchData() {
        let stats = getNetworkStatsUseCase.execute()
        self.networkStats = stats
        
        self.downloadSpeedString = formatBytes(stats.downloadSpeedBytes) + "/s"
        self.uploadSpeedString = formatBytes(stats.uploadSpeedBytes) + "/s"
        self.totalDownloadedString = formatBytes(stats.totalBytesIn)
        self.totalUploadedString = formatBytes(stats.totalBytesOut)
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
