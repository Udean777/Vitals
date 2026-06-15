//
//  ScanLargeFilesUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol ScanLargeFilesUseCase {
    func execute() async -> [LargeFileEntity]
}

final class ScanLargeFilesUseCaseImpl: ScanLargeFilesUseCase {
    private let repository: LargeFilesRepository
    
    init(repository: LargeFilesRepository) {
        self.repository = repository
    }
    
    func execute() async -> [LargeFileEntity] {
        return await repository.scanLargeFiles()
    }
}
