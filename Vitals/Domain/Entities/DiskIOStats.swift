//
//  DiskIOStats.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

struct DiskIOStats {
    let readSpeedBytes: UInt64
    let writeSpeedBytes: UInt64
    let totalReadBytes: UInt64
    let totalWriteBytes: UInt64
}
