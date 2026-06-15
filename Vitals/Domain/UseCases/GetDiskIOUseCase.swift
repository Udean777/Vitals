//
//  GetDiskIOUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol GetDiskIOUseCase: Sendable {
    nonisolated func execute() -> DiskIOStats
}

final class GetDiskIOUseCaseImpl: GetDiskIOUseCase, Sendable {
    private let repository: DiskIORepository
    
    init(repository: DiskIORepository) {
        self.repository = repository
    }
    
    nonisolated func execute() -> DiskIOStats {
        return repository.getDiskIO()
    }
}
