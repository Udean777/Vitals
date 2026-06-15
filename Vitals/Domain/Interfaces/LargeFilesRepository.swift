//
//  LargeFilesRepository.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol LargeFilesRepository {
    func scanLargeFiles() async -> [LargeFileEntity]
}
