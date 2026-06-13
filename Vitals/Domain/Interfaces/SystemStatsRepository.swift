//
//  SystemStatsRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol SystemStatsRepository {
    func getSystemUsage() throws -> SystemUsage
}
