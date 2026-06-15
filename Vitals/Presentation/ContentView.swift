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
            VStack {
                List(SidebarItem.allCases, selection: $selectedMenu) { item in
                    NavigationLink(value: item) {
                        Label(item.rawValue, systemImage: item.iconName)
                            .font(.system(.body, design: .rounded))
                            .padding(.vertical, 4)
                    }
                    .keyboardShortcut(item.shortcutKey, modifiers: .command)
                }
                .listStyle(.sidebar)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                    
                    Text("SYSTEM STATUS")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.Vitals.textSecondary)
                        .tracking(1)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.Vitals.neonGreen)
                            .frame(width: 8, height: 8)
                            .shadow(color: .Vitals.neonGreen.opacity(0.8), radius: 3)
                        
                        Text("All Systems Nominal")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.Vitals.textPrimary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.Vitals.textSecondary)
                        
                        let uptimeString = getUptimeString()
                        Text("Uptime: \(uptimeString)")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.Vitals.textSecondary)
                    }
                }
                .padding(16)
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
    
    private func getUptimeString() -> String {
        var boottime = timeval()
        var size = MemoryLayout<timeval>.stride
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        
        sysctl(&mib, 2, &boottime, &size, nil, 0)
        
        let uptimeSeconds = Date().timeIntervalSince1970 - Double(boottime.tv_sec)
        let hours = Int(uptimeSeconds) / 3600
        let minutes = (Int(uptimeSeconds) % 3600) / 60
        
        return "\(hours)h \(minutes)m"
    }
}

#Preview {
    ContentView()
}
