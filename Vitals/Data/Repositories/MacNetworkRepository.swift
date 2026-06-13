//
//  MacNetworkRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

final class MacNetworkRepository: NetworkRepository {
    private var previousBytesIn: UInt64 = 0
    private var previousBytesOut: UInt64 = 0
    private var lastUpdate: Date = Date()
    
    func getNetworkStats() -> NetworkStats {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var totalBytesIn: UInt64 = 0
        var totalBytesOut: UInt64 = 0
        
        guard getifaddrs(&ifaddr) == 0 else {
            return NetworkStats(totalBytesIn: 0, totalBytesOut: 0, downloadSpeedBytes: 0, uploadSpeedBytes: 0)
        }
        
        var ptr = ifaddr
        while ptr != nil {
            defer {ptr = ptr?.pointee.ifa_next}
            
            guard let interface = ptr?.pointee else {continue}
            
            if interface.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                let name = String(cString: interface.ifa_name)
                
                if name != "lo0", let data = interface.ifa_data {
                    let networkData = data.assumingMemoryBound(to: if_data.self).pointee
                    totalBytesIn += UInt64(networkData.ifi_ibytes)
                    totalBytesOut += UInt64(networkData.ifi_obytes)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        let now = Date()
        let timeDelta = now.timeIntervalSince(lastUpdate)
        
        var downloadSpeed: UInt64 = 0
        var uploadSpeed: UInt64 = 0
        
        if previousBytesIn > 0 && timeDelta > 0 {
            if totalBytesIn >= previousBytesIn {
                downloadSpeed = UInt64(Double(totalBytesIn - previousBytesIn) / timeDelta)
                uploadSpeed = UInt64(Double(totalBytesOut - previousBytesOut) / timeDelta)
            }
        }
        
        self.previousBytesIn = totalBytesIn
        self.previousBytesOut = totalBytesOut
        self.lastUpdate = now
        
        return NetworkStats(totalBytesIn: totalBytesIn, totalBytesOut: totalBytesOut, downloadSpeedBytes: downloadSpeed,
                            uploadSpeedBytes: uploadSpeed)
    }
}
