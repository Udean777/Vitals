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
        
        let now = Date()
        
        if let battery = batteryInfo {
            if battery.isCharging && battery.currentPercentage >= 80.0 {
                if lastBatteryAlertTime == nil || now.timeIntervalSince(lastBatteryAlertTime!) > 3600 {
                    notificationService.sendNotification(
                        identifier: "battery_80_alert",
                        title: "Baterai di \(Int(battery.currentPercentage))%",
                        body: "Pertimbangkan untuk mencabut charger demi kesehatan baterai."
                    )
                    lastBatteryAlertTime = now
                }
            } else if !battery.isCharging && battery.currentPercentage < 80.0 {
                lastBatteryAlertTime = nil
            }
        }
        
        if let usage = systemUsage {
            if usage.cpuLoad > 90.0 {
                if lastCpuAlertTime == nil || now.timeIntervalSince(lastCpuAlertTime!) > 600 {
                    notificationService.sendNotification(
                        identifier: "cpu_high_alert",
                        title: "Penggunaan CPU Tinggi",
                        body: "Beban sistem mencapai \(String(format: "%.0f", usage.cpuLoad))%. Cek Vitals."
                    )
                    lastCpuAlertTime = now
                }
            } else if usage.cpuLoad < 80.0 {
                lastCpuAlertTime = nil
            }
        }
    }
}
