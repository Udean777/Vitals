//
//  ExportSystemReportUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

class ExportSystemReportUseCase {
    func execute(
        deviceInfo: DeviceInfo?,
        batteryInfo: BatteryInfo?,
        systemUsage: SystemUsage?
    ) {
        let report = generateReportString(
            deviceInfo: deviceInfo,
            batteryInfo: batteryInfo,
            systemUsage: systemUsage
        )
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType.plainText]
        panel.nameFieldStringValue = "Vitals_Report_\(Int(Date().timeIntervalSince1970)).txt"
        panel.title = "Save System Report"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    try report.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print("Gagal menyimpan laporan: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func generateReportString(
        deviceInfo: DeviceInfo?,
        batteryInfo: BatteryInfo?,
        systemUsage: SystemUsage?
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        var str = "========================================\n"
        str += "VITALS SYSTEM REPORT\n"
        str += "Generated: \(formatter.string(from: Date()))\n"
        str += "========================================\n\n"
        
        if let device = deviceInfo {
            str += "--- HARDWARE INFO ---\n"
            str += "Model: \(device.modelName)\n"
            str += "Architecture: \(device.cpuArchitecture)\n"
            str += "Cores: \(device.totalCores)\n"
            str += "OS Version: \(device.osVersion)\n\n"
        }
        
        if let usage = systemUsage {
            str += "--- COMPUTE & MEMORY ---\n"
            str += String(format: "CPU Load: %.1f%%\n", usage.cpuLoad)
            str += String(format: "Memory Used: %.1f GB / %.1f GB\n", usage.usedRAM / 1024.0, usage.totalRAM / 1024.0)
            str += String(format: "Swap Used: %.1f MB\n", usage.swapUsed)
            str += "Thermal State: \(usage.thermalState)\n\n"
        }
        
        if let battery = batteryInfo {
            str += "--- BATTERY & POWER ---\n"
            str += String(format: "Level: %.1f%%\n", battery.currentPercentage)
            str += "Status: \(battery.isCharging ? "Charging" : "Discharging")\n"
            str += String(format: "Health: %.1f%%\n", battery.healthPercentage)
            str += "Cycle Count: \(battery.cycleCount)\n"
            str += String(format: "Temperature: %.1f°C\n", battery.temperature)
            str += String(format: "Power Draw: %.2f Watts\n\n", battery.powerDraw)
        }
        
        str += "========================================"
        return str
    }
}
