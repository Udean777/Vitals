//
//  KillProcessUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

final class KillProcessUseCase {
    private let repository: TopProcessesRepository
    
    init(repository: TopProcessesRepository) {
        self.repository = repository
    }
    
    func execute(pid: Int) throws {
        try repository.killProcess(pid: pid)
    }
}
