//
//  VitalsApp.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

@main
struct VitalsApp: App {
    @StateObject private var diContainer = DIContainer()
    @StateObject private var menuBarViewModel: MenuBarViewModel
    
    init() {
        let container = DIContainer()
        
        _menuBarViewModel = StateObject(wrappedValue: MenuBarViewModel(
            systemStatsUseCase: container.systemStatsUseCase,
            getTopProcessesUseCase: container.getTopProcessesUseCase
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diContainer)
        }
        
        MenuBarExtra {
            VStack(alignment: .leading, spacing: 8) {
                Text("Top CPU Hogs")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                if menuBarViewModel.topProcesses.isEmpty {
                    Text("Memuat data...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    ForEach(menuBarViewModel.topProcesses) {process in
                        HStack {
                            Text(process.name)
                                .font(.system(.body, design: .rounded))
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(format: "%.1f%%", process.cpuUsage))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(process.cpuUsage > 50.0 ? .red : .primary)
                        }
                    }
                }
            }
            .padding()
            .frame(width: 280)
            
            Divider()

            Button("Quit Vitals") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            .padding(.bottom, 8)
        } label: {
            Text(menuBarViewModel.summaryText)
                .onAppear{
                    menuBarViewModel.startMonitoring()
                }
        }
        .menuBarExtraStyle(.window)
    }
}
