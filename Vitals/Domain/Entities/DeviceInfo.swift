//
//  DeviceInfo.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

struct DeviceInfo {
    let hostName: String
    let modelName: String
    let osVersion: String
    let totalRAM: Double
    let freeDiskSpace: Double
    let totalDiskSpace: Double
    let purgeableDiskSpace: Double
    let cpuArchitecture: String
    let totalCores: Int
}
