//
//  ProcessEntity.swift.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

struct ProcessEntity: Identifiable {
    let id = UUID()
    let pid: Int
    let name: String
    let cpuUsage: Double
    let ramUsage: Double
}
