//
//  StorageViewModel.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation
import Combine
import Cocoa

@MainActor
final class StorageViewModel: ObservableObject {
    @Published var totalDisk: Double = 1.0
    @Published var freeDisk: Double = 0
    @Published var usedDisk: Double = 0
    @Published var hasFDA: Bool = false
    @Published var isScanning: Bool = false
    @Published var cacheItems: [CacheItem] = []
    @Published var totalCacheSavedString: String = "0 GB"
    @Published var largeFiles: [LargeFileEntity] = []
    @Published var isScanningLargeFiles: Bool = false
    @Published var purgeableDisk: Double = 0
    
    private let scanLargeFilesUseCase: ScanLargeFilesUseCase
    private let getDeviceInfoUseCase: GetDeviceInfoUseCase
    private let checkFDAUseCase: CheckFDAUseCase
    private let scanDeveloperCachesUseCase: ScanDeveloperCachesUseCase
    
    init(getDeviceInfoUseCase: GetDeviceInfoUseCase,
         checkFDAUseCase: CheckFDAUseCase,
         scanDeveloperCachesUseCase: ScanDeveloperCachesUseCase,
         scanLargeFilesUseCase: ScanLargeFilesUseCase) {
        
        self.getDeviceInfoUseCase = getDeviceInfoUseCase
        self.checkFDAUseCase = checkFDAUseCase
        self.scanDeveloperCachesUseCase = scanDeveloperCachesUseCase
        self.scanLargeFilesUseCase = scanLargeFilesUseCase
        
        fetchData()
        checkFDA()
        scanLargeFiles()
    }
    
    func fetchData() {
        let info = getDeviceInfoUseCase.execute()
        self.totalDisk = info.totalDiskSpace
        self.freeDisk = info.freeDiskSpace
        self.usedDisk = info.totalDiskSpace - info.freeDiskSpace
        self.purgeableDisk = info.purgeableDiskSpace
    }
    
    func checkFDA() {
        self.hasFDA = checkFDAUseCase.execute()
    }
    
    func openPrivacySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
        NSWorkspace.shared.open(url)
    }
    
    func openAppLocation() {
        NSWorkspace.shared.activateFileViewerSelecting([Bundle.main.bundleURL])
    }
    
    func startScan() {
        self.isScanning = true
        self.cacheItems.removeAll()
        
        Task {
            let result = await scanDeveloperCachesUseCase.execute()
            
            await MainActor.run {
                self.cacheItems = result
                let totalBytes = result.reduce(0) { $0 + $1.sizeBytes }
                self.totalCacheSavedString = formatBytes(totalBytes)
                self.isScanning = false
            }
        }
    }
    
    private func scanLargeFiles() {
        isScanningLargeFiles = true
        
        Task {
            let files = await scanLargeFilesUseCase.execute()
            
            await MainActor.run {
                self.largeFiles = Array(files.prefix(5))
                self.isScanningLargeFiles = false
            }
        }
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
