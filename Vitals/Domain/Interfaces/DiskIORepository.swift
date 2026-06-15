//
//  DiskIORepository.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol DiskIORepository: Sendable {
    nonisolated func getDiskIO() -> DiskIOStats
}
