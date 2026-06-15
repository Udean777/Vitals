//
//  EnergyAppEntity.swift
//  Vitals
//

import Foundation

struct EnergyAppEntity: Identifiable {
    let id = UUID()
    let pid: Int
    let name: String
    let power: Double
}
