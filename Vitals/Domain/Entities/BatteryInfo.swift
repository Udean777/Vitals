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
    let cycleCount: Int
    let isCharging: Bool
    let temperature: Double
    let powerDraw: Double
    let timeRemaining: Int
    
    var currentPercentage: Double {
        guard maxCapacity > 0 else { return 0 }
        return (Double(currentCapacity) / Double(maxCapacity)) * 100
    }
    
    var healthPercentage: Double {
        guard designCapacity > 0 else { return 0 }
        return (Double(maxCapacity) / Double(designCapacity)) * 100
    }
}
