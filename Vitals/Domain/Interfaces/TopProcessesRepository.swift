//
//  TopProcessesRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol TopProcessesRepository {
    func getTopProcess(limit: Int) throws -> [ProcessEntity]
}
