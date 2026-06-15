//
//  LargeFileEntity.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

struct LargeFileEntity: Identifiable {
    let id = UUID()
    let name: String
    let sizeBytes: UInt64
    let path: String
}
