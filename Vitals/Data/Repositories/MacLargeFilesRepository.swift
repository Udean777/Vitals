//
//  MacLargeFilesRepository.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

final class MacLargeFilesRepository: LargeFilesRepository {
    func scanLargeFiles() async -> [LargeFileEntity] {
        let fileManager = FileManager.default
        guard let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first,
              let desktopURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first,
              let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let urlsToScan = [downloadsURL, desktopURL, documentsURL]
        var largeFiles: [LargeFileEntity] = []
        
        await Task.detached {
            for url in urlsToScan {
                if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
                                                           options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                    while let fileURL = enumerator.nextObject() as? URL {
                        do {
                            let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey])
                            if let isDirectory = resourceValues.isDirectory, !isDirectory {
                                if let fileSize = resourceValues.fileSize {
                                    if fileSize > 100_000_000 {
                                        largeFiles.append(LargeFileEntity(
                                            name: fileURL.lastPathComponent,
                                            sizeBytes: UInt64(fileSize),
                                            path: fileURL.path
                                        ))
                                    }
                                }
                            }
                        } catch {
                            continue
                        }
                    }
                }
            }
        }.value
        
        return largeFiles.sorted { $0.sizeBytes > $1.sizeBytes }
    }
}
