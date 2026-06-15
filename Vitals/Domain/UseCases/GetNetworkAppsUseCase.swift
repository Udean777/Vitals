//
//  GetNetworkAppsUseCase.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol GetNetworkAppsUseCase {
    func execute() -> [NetworkAppEntity]
}

final class GetNetworkAppsUseCaseImpl: GetNetworkAppsUseCase {
    private let repository: NetworkAppsRepository
    
    init(repository: NetworkAppsRepository) {
        self.repository = repository
    }
    
    func execute() -> [NetworkAppEntity] {
        return repository.getActiveNetworkApps()
    }
}
