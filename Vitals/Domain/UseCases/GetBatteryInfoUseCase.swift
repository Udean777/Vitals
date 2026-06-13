//
//  GetBatteryInfoUseCase.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

protocol GetBatteryInfoUseCase {
    func execute() throws -> BatteryInfo
}

final class GetBatteryInfoUseCaseImpl: GetBatteryInfoUseCase {
    private let repository: BatteryRepository
    init(repository: BatteryRepository) { self.repository = repository }
    
    func execute() throws -> BatteryInfo {
        return try repository.getBatteryInfo()
    }
}
