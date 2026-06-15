//
//  SystemAlertsUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

final class SystemAlertsUseCase {
    private let notificationService: NotificationService
    private var lastBatteryAlertTime: Date?
    private var lastCpuAlertTime: Date?
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }
    
    func execute(batteryInfo: BatteryInfo?, systemUsage: SystemUsage?) {
        let alertsEnabled = UserDefaults.standard.bool(forKey: "systemAlertsEnabled")
        guard alertsEnabled else { return }
        
        let cpuThreshold = UserDefaults.standard.object(forKey: "cpuAlertThreshold") as? Double ?? 90.0
        let batteryThreshold = UserDefaults.standard.object(forKey: "batteryAlertThreshold") as? Double ?? 80.0
        
        let now = Date()
        
        if let battery = batteryInfo {
            if battery.isCharging && battery.currentPercentage >= batteryThreshold {
                if lastBatteryAlertTime == nil || now.timeIntervalSince(lastBatteryAlertTime!) > 3600 {
                    notificationService.sendNotification(
                        identifier: "battery_80_alert",
                        title: "Baterai di \(Int(battery.currentPercentage))%",
                        body: "Pertimbangkan untuk mencabut charger demi kesehatan baterai."
                    )
                    lastBatteryAlertTime = now
                }
            } else if !battery.isCharging && battery.currentPercentage < batteryThreshold {
                lastBatteryAlertTime = nil
            }
        }
        
        if let usage = systemUsage {
            if usage.cpuLoad > cpuThreshold {
                if lastCpuAlertTime == nil || now.timeIntervalSince(lastCpuAlertTime!) > 600 {
                    notificationService.sendNotification(
                        identifier: "cpu_high_alert",
                        title: "Penggunaan CPU Tinggi",
                        body: "Beban sistem mencapai \(String(format: "%.0f", usage.cpuLoad))%. Cek Vitals."
                    )
                    lastCpuAlertTime = now
                }
            } else if usage.cpuLoad < cpuThreshold - 10.0 {
                lastCpuAlertTime = nil
            }
        }
    }
}
