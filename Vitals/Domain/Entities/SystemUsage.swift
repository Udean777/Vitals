//
//  SystemUsage.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

struct SystemUsage {
    let cpuLoad: Double
    let totalRAM: Double
    let usedRAM: Double
    let appMemory: Double
    let wiredMemory: Double
    let compressedMemory: Double
    let cachedFiles: Double
    
    var ramUsagePercentage: Double {
        guard totalRAM > 0 else {return 0.0}
        return usedRAM / totalRAM
    }
}
