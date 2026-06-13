//
//  GetNetworkStatsUseCase.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol GetNetworkStatsUseCase {
    func execute() -> NetworkStats
}

final class GetNetworkStatsUseCaseImpl: GetNetworkStatsUseCase {
    private let repository: NetworkRepository
    init(repository: NetworkRepository) { self.repository = repository }
    
    func execute() -> NetworkStats {
        return repository.getNetworkStats()
    }
}
