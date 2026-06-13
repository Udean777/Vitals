//
//  NetworkRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol NetworkRepository {
    func getNetworkStats() -> NetworkStats
}
