//
//  MacBatteryRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

final class MacBatteryRepository: BatteryRepository {
    func getBatteryInfo() throws -> BatteryInfo {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.launchPath = "/usr/sbin/ioreg"
        task.arguments = ["-rn", "AppleSmartBattery"]
        
        try task.run()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Batter Error", code: 1, userInfo: nil)
        }
        
        let maxCap = extractInt(from: output, key: "\"AppleRawMaxCapacity\"") ?? extractInt(from: output, key: "\"MaxCapacity\"") ?? 100
        let currentCap = extractInt(from: output, key: "\"AppleRawCurrentCapacity\"") ?? extractInt(from: output, key: "\"CurrentCapacity\"")
        ?? 0
        let designCap = extractInt(from: output, key: "\"DesignCapacity\"") ?? 100
        let cycleCount = extractInt(from: output, key: "\"CycleCount\"") ?? 0
        let isChargingStr = extractString(from: output, key: "\"IsCharging\"") ?? "No"
        
        return BatteryInfo(
            currentCapacity: currentCap,
            maxCapacity: maxCap,
            designCapacity: designCap,
            cycleCount: cycleCount,
            isCharging: (isChargingStr == "Yes" || isChargingStr == "true")
        )
    }
    
    private func extractInt(from text: String, key: String) -> Int? {
        guard let range = text.range(of: "\(key) = ") else { return nil }
        let substring = text[range.upperBound...]
        
        if let endRange = substring.range(of: "\n") {
            let valueStr = substring[..<endRange.lowerBound].trimmingCharacters(in: .whitespaces)
            return Int(valueStr)
        }
        
        return nil
    }
    
    private func extractString(from text: String, key: String) -> String? {
        guard let range = text.range(of: "\(key) = ") else { return nil }
        let substring = text[range.upperBound...]
        if let endRange = substring.range(of: "\n") {
            return substring[..<endRange.lowerBound].trimmingCharacters(in: .whitespaces)
        }
        return nil
    }
}
