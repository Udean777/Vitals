//
//  SystemStatsUseCase.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol SystemStatsUseCase {
    func execute() throws -> SystemUsage
}

final class SystemStatsUseCaseImpl: SystemStatsUseCase {
    private let repository: SystemStatsRepository
    
    init(repository: SystemStatsRepository) {
        self.repository = repository
    }
    
    func execute() throws -> SystemUsage {
        return try repository.getSystemUsage()
    }
}
