//
//  BatteryRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol BatteryRepository {
    func getBatteryInfo() throws -> BatteryInfo
}
