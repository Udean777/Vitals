//
//  BatteryInfo.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

struct BatteryInfo {
    let currentCapacity: Int
    let maxCapacity: Int
    let designCapacity: Int
    let rawCurrentCapacity: Int
    let rawMaxCapacity: Int
    let cycleCount: Int
    let isCharging: Bool
    let temperature: Double
    let powerDraw: Double
    let timeRemaining: Int
    
    var currentPercentage: Double {
        return Double(currentCapacity)
    }
    
    var healthPercentage: Double {
        guard designCapacity > 0 else { return 0 }
        return (Double(rawMaxCapacity) / Double(designCapacity)) * 100
    }
}
