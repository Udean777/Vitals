//
//  ScanDeveloperCachesUseCase.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

protocol ScanDeveloperCachesUseCase {
    func execute() async -> [CacheItem]
}

final class DefaultScanDeveloperCachesUseCase: ScanDeveloperCachesUseCase {
    private let repository: CacheScannerRepository
    
    init(repository: CacheScannerRepository) {
        self.repository = repository
    }
    
    func execute() async -> [CacheItem] {
        return await repository.scanDeveloperCaches()
    }
}
