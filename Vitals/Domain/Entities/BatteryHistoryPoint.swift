//
//  BatteryHistoryPoint.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

struct BatteryHistoryPoint: Identifiable, Codable {
    var id: UUID = UUID()
    let timestamp: Date
    let percentage: Double
}
