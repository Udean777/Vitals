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
            getBatteryInfoUseCase: container.getBatteryInfoUseCase
        ))
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
                // --- TOP STATS (CPU, RAM, BATTERY) ---
                HStack(spacing: 0) {
                    // CPU
                    VStack {
                        Text("CPU").font(.caption2).foregroundColor(.Vitals.textSecondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: "cpu").foregroundColor(.Vitals.neonTeal).font(.caption)
                            Text(String(format: "%.0f%%", menuBarViewModel.cpuLoad))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                    }.frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30).background(Color.Vitals.cardBorder)
                    
                    // RAM
                    VStack {
                        Text("RAM").font(.caption2).foregroundColor(.Vitals.textSecondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: "memorychip").foregroundColor(.Vitals.neonYellow).font(.caption)
                            Text(String(format: "%.0f", menuBarViewModel.usedRAM))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Text(String(format: "/%.0fGB", menuBarViewModel.totalRAM))
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(.Vitals.textSecondary)
                        }
                    }.frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30).background(Color.Vitals.cardBorder)
                    
                    // BATTERY
                    VStack {
                        Text("BATTERY").font(.caption2).foregroundColor(.Vitals.textSecondary).tracking(1)
                        HStack(spacing: 4) {
                            Image(systemName: menuBarViewModel.batteryInfo?.isCharging == true ? "bolt.fill" : "battery.100")
                                .foregroundColor(menuBarViewModel.batteryInfo?.isCharging == true ? .Vitals.neonGreen : .Vitals.neonTeal)
                                .font(.caption)
                            Text(String(format: "%.0f%%", menuBarViewModel.batteryInfo?.currentPercentage ?? 0))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                    }.frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .background(Color.Vitals.cardBackground)
                
                Divider().background(Color.Vitals.cardBorder)
                
                // --- TOP PROCESSES ---
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.caption2)
                            .foregroundColor(.Vitals.textSecondary)
                        Text("TOP PROCESSES")
                            .font(.caption2)
                            .foregroundColor(.Vitals.textSecondary)
                            .tracking(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    if menuBarViewModel.topProcesses.isEmpty {
                        Text("Memuat data...")
                            .foregroundColor(.Vitals.textSecondary)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    } else {
                        ForEach(menuBarViewModel.topProcesses) { process in
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.Vitals.cardBorder)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Image(systemName: "terminal")
                                            .font(.system(size: 10))
                                            .foregroundColor(.Vitals.textSecondary)
                                    )
                                
                                Text(process.name)
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(.Vitals.textPrimary)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(format: "%.0f%%", process.cpuUsage))
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(process.cpuUsage > 50.0 ? .Vitals.neonPink : .Vitals.neonTeal)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // --- DEVELOPER WORKLOAD (Fake Local LLM Box) ---
                    if !menuBarViewModel.devProcesses.isEmpty {
                        VStack(spacing: 8) {
                            HStack {
                                Circle().fill(Color.Vitals.neonTeal).frame(width: 6, height: 6)
                                    .shadow(color: .Vitals.neonTeal, radius: 4)
                                Text("Local LLM Active")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.Vitals.neonTeal)
                                Spacer()
                                Text("VRAM USAGE")
                                    .font(.system(size: 10))
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                            HStack {
                                Text("24 tokens/s")
                                    .font(.system(size: 12))
                                    .foregroundColor(.Vitals.textSecondary)
                                Spacer()
                                Text("4GB ")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.Vitals.textPrimary)
                                + Text("Active")
                                    .font(.system(size: 12))
                                    .foregroundColor(.Vitals.neonTeal)
                            }
                        }
                        .padding(12)
                        .background(Color.Vitals.cardBackground)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.Vitals.neonTeal.opacity(0.3), lineWidth: 1))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }
                }
                
                Divider().background(Color.Vitals.cardBorder).padding(.top, 16)
                
                // --- POWER STATUS ---
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.Vitals.neonYellow)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Power Status")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.Vitals.textPrimary)
                            Text(menuBarViewModel.batteryInfo?.isCharging == true ? "Charging..." : "On Battery")
                                .font(.system(size: 11))
                                .foregroundColor(.Vitals.textSecondary)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.0f%%", menuBarViewModel.batteryInfo?.currentPercentage ?? 0))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.Vitals.textPrimary)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.Vitals.cardBorder).frame(height: 6)
                            Capsule()
                                .fill(Color.Vitals.neonTeal)
                                .frame(width: geo.size.width * CGFloat((menuBarViewModel.batteryInfo?.currentPercentage ?? 0) / 100.0), height: 6)
                                .shadow(color: .Vitals.neonTeal, radius: 4)
                        }
                    }.frame(height: 6)
                }
                .padding(16)
                
                Divider().background(Color.Vitals.cardBorder)
                
                // --- BOTTOM ACTION BAR ---
                HStack {
                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.Vitals.textSecondary)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        // Open Activity Monitor
                    }) {
                        Text("Activity Monitor")
                            .font(.system(size: 11))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.Vitals.cardBorder)
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
                .background(Color.Vitals.cardBackground)
                
            }
            .frame(width: 320)
            .background(Color.Vitals.background)
            .preferredColorScheme(.dark)
            
        } label: {
            Text(menuBarViewModel.summaryText)
                .onAppear {
                    menuBarViewModel.startMonitoring()
                }
        }
        .menuBarExtraStyle(.window)
    }
}
