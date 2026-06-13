//
//  ContentView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMenu: SidebarItem? = .overview
    
    var body: some View {
        NavigationSplitView{
            List(SidebarItem.allCases, selection: $selectedMenu) {item in
                NavigationLink(value: item) {
                    Label(item.rawValue, systemImage: item.iconName)
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle("Vitals")
            .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 250)
        } detail: {
            if let selected = selectedMenu {
                switch selected {
                case .overview: OverviewView()
                case .battery: BatteryView()
                case .compute: ComputeView()
                case .network: NetworkView()
                case .storage: StorageView()
                }
            } else {
                Text("Pilih menu di sidebar")
            }
        }
        .tint(.Vitals.neonTeal)
    }
}

#Preview {
    ContentView()
}
