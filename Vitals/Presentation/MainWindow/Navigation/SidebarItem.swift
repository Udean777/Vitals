//
//  SidebarItem.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

enum SidebarItem: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case battery = "Battery & Power"
    case compute = "Compute & Memory"
    case network = "Network"
    case storage = "Storage Analyzer"
    
    var id: String { self.rawValue }
    
    // Ikon SF Symbols untuk masing-masing menu
    var iconName: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .battery: return "battery.100.bolt"
        case .compute: return "cpu"
        case .network: return "network"
        case .storage: return "internaldrive"
        }
    }
}
