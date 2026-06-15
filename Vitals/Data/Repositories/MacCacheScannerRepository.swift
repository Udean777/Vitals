//
//  MacCacheScannerRepository.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

protocol CacheScannerRepository {
    func hasFullDiskAccess() -> Bool
    func scanDeveloperCaches() async -> [CacheItem]
}

final class MacCacheScannerRepository: CacheScannerRepository {
    private let fileManager = FileManager.default
    
    func hasFullDiskAccess() -> Bool {
        let testPaths = [
            NSHomeDirectory() + "/Library/Messages/chat.db",
            NSHomeDirectory() + "/Library/Safari/Bookmarks.plist",
            "/Library/Application Support/com.apple.TCC/TCC.db"
        ]
        
        return testPaths.contains { fileManager.isReadableFile(atPath: $0) }
    }
    
    func scanDeveloperCaches() async -> [CacheItem] {
        var items: [CacheItem] = []
        let home = NSHomeDirectory()
        
        let targetPaths = [
            ("Xcode Derived Data", home + "/Library/Developer/Xcode/DerivedData"),
            ("Xcode iOS Archives", home + "/Library/Developer/Xcode/Archives"),
            ("Gradle Caches", home + "/.gradle/caches"),
            ("Android Emulators", home + "/.android/avd"),
            ("CocoaPods Cache", home + "/Library/Caches/CocoaPods")
        ]
        
        for target in targetPaths {
            await Task.yield()
            
            let size = calculateDirectorySize(at: target.1)
            if size > 0 {
                items.append(CacheItem(name: target.0, path: target.1, sizeBytes: size))
            }
        }
        return items
    }
    
    private func calculateDirectorySize(at path: String) -> UInt64 {
        guard let enumerator = fileManager.enumerator(atPath: path) else {return 0}
        var totalSize: UInt64 = 0
        
        for file in enumerator {
            guard let relativePath = file as? String else { continue }
            let fullPath = path + "/" + relativePath
            
            if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
               let size = attrs[.size] as? UInt64 {
                totalSize += size
            }
        }
        
        return totalSize
    }
}
