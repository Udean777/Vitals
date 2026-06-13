//
//  GetDeviceInfoUseCase.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol GetDeviceInfoUseCase {
    func execute() -> DeviceInfo
}

final class GetDeviceInfoUseCaseImpl: GetDeviceInfoUseCase {
    private let repository: DeviceInfoRepository
    
    init(repository: DeviceInfoRepository) {
        self.repository = repository
    }
    
    func execute() -> DeviceInfo {
        return repository.getDeviceInfo()
    }
}
