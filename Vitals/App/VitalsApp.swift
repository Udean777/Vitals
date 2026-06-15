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
        _diContainer = StateObject(wrappedValue: container)
        
        _menuBarViewModel = StateObject(wrappedValue: MenuBarViewModel(
            systemStatsUseCase: container.systemStatsUseCase,
            getTopProcessesUseCase: container.getTopProcessesUseCase,
            getBatteryInfoUseCase: container.getBatteryInfoUseCase,
            systemAlertsUseCase: container.systemAlertsUseCase
        ))
        
        container.notificationService.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diContainer)
        }
        .windowStyle(.hiddenTitleBar)
        
        Settings {
            SettingsView()
        }
        
        MenuBarExtra {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack {
                        Text("CPU").font(.caption2).foregroundColor(.secondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: "cpu").foregroundColor(.blue).font(.caption)
                            Text(String(format: "%.0f%%", menuBarViewModel.cpuLoad))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }.frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30)
                    
                    VStack {
                        Text("RAM").font(.caption2).foregroundColor(.secondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: "memorychip").foregroundColor(.purple).font(.caption)
                            Text(String(format: "%.0f", menuBarViewModel.usedRAM))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text(String(format: "/%.0fGB", menuBarViewModel.totalRAM))
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }.frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30)
                    
                    VStack {
                        Text("BATTERY").font(.caption2).foregroundColor(.secondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: menuBarViewModel.batteryInfo?.isCharging == true ? "bolt.fill" : "battery.100")
                                .foregroundColor(menuBarViewModel.batteryInfo?.isCharging == true ? .green : .orange)
                                .font(.caption)
                            Text(String(format: "%.0f%%", menuBarViewModel.batteryInfo?.currentPercentage ?? 0.0))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }.frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("TOP PROCESSES")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .tracking(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    if menuBarViewModel.topProcesses.isEmpty {
                        Text("Memuat data...")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    } else {
                        ForEach(menuBarViewModel.topProcesses) { process in
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(NSColor.controlColor))
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Image(systemName: "terminal")
                                            .font(.system(size: 10))
                                            .foregroundColor(.secondary)
                                    )
                                
                                Text(process.name)
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(format: "%.0f%%", process.cpuUsage))
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(process.cpuUsage > 50.0 ? .red : .primary)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                
                if !menuBarViewModel.devProcesses.isEmpty {
                    Divider().padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "hammer.fill")
                                .font(.caption2)
                                .foregroundColor(.purple)
                            Text("DEV WORKLOAD")
                                .font(.caption2)
                                .foregroundColor(.purple)
                                .tracking(1)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        ForEach(menuBarViewModel.devProcesses) { process in
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.purple.opacity(0.1))
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Image(systemName: "curlybraces")
                                            .font(.system(size: 10))
                                            .foregroundColor(.purple)
                                    )
                                
                                Text(process.name)
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(format: "%.0f%%", process.cpuUsage))
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(.purple)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                
                Divider().padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Power Status")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                            Text(menuBarViewModel.batteryInfo?.isCharging == true ? "Charging..." : "On Battery")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.0f%%", menuBarViewModel.batteryInfo?.currentPercentage ?? 0.0))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(NSColor.separatorColor)).frame(height: 6)
                            Capsule()
                                .fill(menuBarViewModel.batteryInfo?.isCharging == true ? Color.green : Color.blue)
                                .frame(width: geo.size.width * CGFloat((menuBarViewModel.batteryInfo?.currentPercentage ?? 0.0) / 100.0), height: 6)
                        }
                    }.frame(height: 6)
                }
                .padding(16)
                
                Divider()
                
                HStack {
                    MenuBarButton(icon: "gearshape.fill", title: "Quit", color: .red) {
                        NSApplication.shared.terminate(nil)
                    }
                    
                    Spacer()
                    
                    MenuBarButton(icon: "waveform.path.ecg", title: "Activity Monitor", color: .blue) {
                        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.ActivityMonitor") {
                            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
                        }
                    }
                }
                .padding(12)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
                
            }
            .frame(width: 320)
            .background(.regularMaterial)
            
        } label: {
            Text(menuBarViewModel.summaryText)
                .onAppear {
                    menuBarViewModel.startMonitoring()
                }
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuBarButton: View {
    var icon: String
    var title: String
    var color: Color
    var action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(isHovered ? color : .secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isHovered ? color.opacity(0.15) : Color(NSColor.controlColor))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isHovered ? color.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}
