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
    let swapUsed: Double
    let thermalState: String
    let memoryPressure: MemoryPressureLevel
    
    var ramUsagePercentage: Double {
        guard totalRAM > 0 else {return 0.0}
        return usedRAM / totalRAM
    }
}

enum MemoryPressureLevel {
    case normal
    case warning
    case critical
    
    var label: String {
        switch self {
        case .normal: return "Normal"
        case .warning: return "Warning"
        case .critical: return "Critical"
        }
    }
    
    var color: String {
        switch self {
        case .normal:   return "neonGreen"
        case .warning:  return "neonYellow"
        case .critical: return "neonPink"
        }
    }
}
