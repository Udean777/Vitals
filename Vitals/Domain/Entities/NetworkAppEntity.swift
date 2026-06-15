//
//  NetworkAppEntity.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

struct NetworkAppEntity: Identifiable {
    let id = UUID()
    let name: String
    let bytesIn: Double
    let bytesOut: Double
}
