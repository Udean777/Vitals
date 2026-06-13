//
//  OverviewViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published var deviceInfo: DeviceInfo?
    
    private let getDeviceInfoUseCase: GetDeviceInfoUseCase
    
    init(getDeviceInfoUseCase: GetDeviceInfoUseCase) {
        self.getDeviceInfoUseCase = getDeviceInfoUseCase
        fetchData()
    }
    
    func fetchData() {
        self.deviceInfo = getDeviceInfoUseCase.execute()
    }
}
