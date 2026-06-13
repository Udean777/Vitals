//
//  GetTopProcessesUseCase.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol GetTopProcessesUseCase {
    func execute(limit: Int) throws -> [ProcessEntity]
}

final class GetTopProcessesUseCaseImpl: GetTopProcessesUseCase {
    private let repository: TopProcessesRepository
    
    init(repository: TopProcessesRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int) throws -> [ProcessEntity] {
        return try repository.getTopProcess(limit: limit)
    }
}
