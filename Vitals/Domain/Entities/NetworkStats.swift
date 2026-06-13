//
//  NetworkStats.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

struct NetworkStats {
    let totalBytesIn: UInt64
    let totalBytesOut: UInt64
    
    // Kecepatan per detik (Real-time)
    let downloadSpeedBytes: UInt64
    let uploadSpeedBytes: UInt64
}
