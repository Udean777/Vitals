//
//  StorageViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine

@MainActor
final class StorageViewModel: ObservableObject {
    @Published var totalDisk: Double = 1.0
    @Published var freeDisk: Double = 0
    @Published var usedDisk: Double = 0
    
    private let getDeviceInfoUseCase: GetDeviceInfoUseCase
    
    init(getDeviceInfoUseCase: GetDeviceInfoUseCase) {
        self.getDeviceInfoUseCase = getDeviceInfoUseCase
        fetchData()
    }
    
    func fetchData() {
        let info = getDeviceInfoUseCase.execute()
        
        self.totalDisk = info.totalDiskSpace
        self.freeDisk = info.freeDiskSpace
        self.usedDisk = info.totalDiskSpace - info.freeDiskSpace
    }
}
