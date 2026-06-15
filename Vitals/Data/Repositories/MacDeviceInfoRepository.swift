//
//  MacDeviceInfoRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

final class MacDeviceInfoRepository: DeviceInfoRepository {
    func getDeviceInfo() -> DeviceInfo {
        let hostName = Host.current().localizedName ?? "Unknown Mac"
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let totalCores = ProcessInfo.processInfo.processorCount
        
        var hwSize = 0
        sysctlbyname("hw.model", nil, &hwSize, nil, 0)
        var hwModel = [CChar](repeating: 0, count: hwSize)
        sysctlbyname("hw.model", &hwModel, &hwSize, nil, 0)
        let modelName = String(cString: hwModel)
        
        var archSize = 0
        sysctlbyname("hw.machine", nil, &archSize, nil, 0)
        var archChars = [CChar](repeating: 0, count: archSize)
        sysctlbyname("hw.machine", &archChars, &archSize, nil, 0)
        let rawArch = String(cString: archChars)
        let cpuArchitecture = rawArch == "arm64" ? "Apple Silicon (ARM64)" : "Intel (x86_64)"
        
        let totalRAMBytes = ProcessInfo.processInfo.physicalMemory
        let totalRAMGB = Double(totalRAMBytes) / 1_073_741_824.0
        
        var freeDiskGB = 0.0
        var totalDiskGB = 0.0
        var purgeableGB = 0.0
        
        do {
            let fileURL = URL(fileURLWithPath: "/")
            let keys: [URLResourceKey] = [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeAvailableCapacityForOpportunisticUsageKey,
                .volumeTotalCapacityKey
            ]
            let values = try fileURL.resourceValues(forKeys: Set(keys))
            
            if let free = values.volumeAvailableCapacityForImportantUsage {
                freeDiskGB = Double(free) / 1_073_741_824.0
            }
            if let total = values.volumeTotalCapacity {
                totalDiskGB = Double(total) / 1_073_741_824.0
            }
            if let opportunistic = values.volumeAvailableCapacityForOpportunisticUsage,
               let important = values.volumeAvailableCapacityForImportantUsage {
                let diff = opportunistic - important
                if diff > 0 { purgeableGB = Double(diff) / 1_073_741_824.0 }
            }
        } catch {
            print("Gagal membaca status disk: \(error)")
        }
        
        return DeviceInfo(
            hostName: hostName,
            modelName: modelName,
            osVersion: osVersion,
            totalRAM: totalRAMGB,
            freeDiskSpace: freeDiskGB,
            totalDiskSpace: totalDiskGB,
            purgeableDiskSpace: purgeableGB,
            cpuArchitecture: cpuArchitecture,
            totalCores: totalCores
        )
    }
}
