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
        
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        let modelName = String(cString: model)
        
        let totalRAMBytes = ProcessInfo.processInfo.physicalMemory
        let totalRAMGB = Double(totalRAMBytes) / 1_073_741_824.0
        
        var freeDiskGB = 0.0
        var totalDiskGB = 0.0
        do {
            let fileURL = URL(fileURLWithPath: "/")
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
            
            if let free = values.volumeAvailableCapacityForImportantUsage {
                freeDiskGB = Double(free) / 1_073_741_824.0
            }
            if let total = values.volumeTotalCapacity {
                totalDiskGB = Double(total) / 1_073_741_824.0
            }
        } catch {
            print("Gagal membaca status disk: \(error)")
        }
        
        return DeviceInfo(hostName: hostName,
                          modelName: modelName,
                          osVersion: osVersion,
                          totalRAM: totalRAMGB,
                          freeDiskSpace: freeDiskGB,
                          totalDiskSpace: totalDiskGB)
    }
}
