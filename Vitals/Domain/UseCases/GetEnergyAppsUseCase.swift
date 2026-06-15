//
//  GetEnergyAppsUseCase.swift
//  Vitals
//

import Foundation

protocol GetEnergyAppsUseCase: Sendable {
    nonisolated func execute(limit: Int) -> [EnergyAppEntity]
}

final class GetEnergyAppsUseCaseImpl: GetEnergyAppsUseCase, Sendable {
    private let repository: EnergyAppsRepository
    
    init(repository: EnergyAppsRepository) {
        self.repository = repository
    }
    
    nonisolated func execute(limit: Int) -> [EnergyAppEntity] {
        return repository.getTopEnergyApps(limit: limit)
    }
}
