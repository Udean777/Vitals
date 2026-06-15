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
    @Published var downloadHistory: [Double] = Array(repeating: 0, count: 20)
    @Published var uploadHistory: [Double] = Array(repeating: 0, count: 20)
    @Published var maxDownload: Double = 100
    @Published var maxUpload: Double = 100
    @Published var activeApps: [NetworkAppEntity] = []
    @Published var localIP: String = "Mencari..."
    @Published var ssid: String = "Mencari..."
    @Published var publicIP: String = "Mencari..."
    
    nonisolated private let getNetworkAppsUseCase: GetNetworkAppsUseCase
    nonisolated private let getNetworkStatsUseCase: GetNetworkStatsUseCase
    private var timer: AnyCancellable?
    
    init(getNetworkStatsUseCase: GetNetworkStatsUseCase,
         getNetworkAppsUseCase: GetNetworkAppsUseCase) {
        self.getNetworkStatsUseCase = getNetworkStatsUseCase
        self.getNetworkAppsUseCase = getNetworkAppsUseCase
        
        fetchNetworkDetails()
        fetchPublicIP()
    }
    
    func startMonitoring() {
        _ = getNetworkStatsUseCase.execute()
        
        let interval = UserDefaults.standard.double(forKey: "refreshIntervalSeconds")
        let safeInterval = interval > 0 ? interval : 1.0
        
        timer = Timer.publish(every: safeInterval, on: .main, in: .common)
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
        
        let downDouble = Double(stats.downloadSpeedBytes)
        let upDouble = Double(stats.uploadSpeedBytes)
        
        downloadHistory.removeFirst()
        downloadHistory.append(downDouble)
        
        uploadHistory.removeFirst()
        uploadHistory.append(upDouble)
        
        if let maxD = downloadHistory.max(), maxD > maxDownload { maxDownload = maxD }
        if let maxU = uploadHistory.max(), maxU > maxUpload { maxUpload = maxU }
        
        if (downloadHistory.max() ?? 0) < maxDownload / 2 { maxDownload = maxDownload * 0.9 }
        if (uploadHistory.max() ?? 0) < maxUpload / 2 { maxUpload = maxUpload * 0.9 }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let apps = self.getNetworkAppsUseCase.execute()
            
            DispatchQueue.main.async {
                self.activeApps = Array(apps.prefix(3))
            }
        }
    }
    
    private func fetchPublicIP() {
        Task {
            do {
                guard let url = URL(string: "https://api.ipify.org") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                if let ip = String(data: data, encoding: .utf8) {
                    await MainActor.run { [weak self] in
                        self?.publicIP = ip
                    }
                }
            } catch {
                await MainActor.run {[weak self] in
                    self?.publicIP = "Offline / Gagal"
                }
            }
        }
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    private func fetchNetworkDetails() {
        var address: String = "Offline"
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let interface = ptr!.pointee
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) { // IPv4
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" || name == "en1" { // Wi-Fi atau Ethernet
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        self.localIP = address
        
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launchPath = "/usr/sbin/networksetup"
            task.arguments = ["-getairportnetwork", "en0"]
            try? task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            var currentSSID = "LAN / Unknown"
            if let output = String(data: data, encoding: .utf8), output.contains("Current Wi-Fi Network") {
                currentSSID = output.components(separatedBy: ": ").last?.trimmingCharacters(in: .whitespacesAndNewlines) ??
                currentSSID
            }
            DispatchQueue.main.async {
                self.ssid = currentSSID
            }
        }
    }
}
