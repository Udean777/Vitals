//
//  CacheItem.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

struct CacheItem: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let sizeBytes: UInt64
}
