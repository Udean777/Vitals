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
            throw NSError(domain: "BatteryError", code: 1, userInfo: nil)
        }
        
        let currentCap = extractInt(from: output, key: "\"CurrentCapacity\"") ?? 0
        let maxCap = extractInt(from: output, key: "\"MaxCapacity\"") ?? 100
        
        let rawMaxCap = extractInt(from: output, key: "\"AppleRawMaxCapacity\"") ?? maxCap
        let rawCurrentCap = extractInt(from: output, key: "\"AppleRawCurrentCapacity\"") ?? currentCap
        let designCap = extractInt(from: output, key: "\"DesignCapacity\"") ?? 4629
        
        let cycleCount = extractInt(from: output, key: "\"CycleCount\"") ?? 0
        let isChargingStr = extractString(from: output, key: "\"IsCharging\"") ?? "No"
        let timeRemaining = extractInt(from: output, key: "\"TimeRemaining\"") ?? 0
        
        let tempRaw = extractInt(from: output, key: "\"Temperature\"") ?? 0
        let tempCelsius = tempRaw > 0 ? (Double(tempRaw) / 10.0) - 273.15 : 0.0
        
        let amperage = extractInt64(from: output, key: "\"Amperage\"") ?? 0
        let voltage = extractInt64(from: output, key: "\"Voltage\"") ?? 0
        let powerDraw = (Double(amperage) / 1000.0) * (Double(voltage) / 1000.0)
        
        return BatteryInfo(
            currentCapacity: currentCap,
            maxCapacity: maxCap,
            designCapacity: designCap,
            rawCurrentCapacity: rawCurrentCap,
            rawMaxCapacity: rawMaxCap,
            cycleCount: cycleCount,
            isCharging: (isChargingStr == "Yes" || isChargingStr == "true"),
            temperature: tempCelsius,
            powerDraw: powerDraw,
            timeRemaining: timeRemaining
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
    
    private func extractInt64(from text: String, key: String) -> Int64? {
        guard let range = text.range(of: "\(key) = ") else { return nil }
        let substring = text[range.upperBound...]
        if let endRange = substring.range(of: "\n") {
            let valueStr = substring[..<endRange.lowerBound].trimmingCharacters(in: .whitespaces)
            if let uintVal = UInt64(valueStr) {
                return Int64(bitPattern: uintVal)
            }
            return Int64(valueStr)
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
