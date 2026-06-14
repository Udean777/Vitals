//
//  CheckFDAUseCase.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

protocol CheckFDAUseCase {
    func execute() -> Bool
}

final class DefaultCheckFDAUseCase: CheckFDAUseCase {
    private let repository: CacheScannerRepository
    
    init(repository: CacheScannerRepository) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        return repository.hasFullDiskAccess()
    }
}
