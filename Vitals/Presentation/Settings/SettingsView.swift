//
//  SettingsView.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("systemAlertsEnabled") private var systemAlertsEnabled = true
    @AppStorage("refreshIntervalSeconds") private var refreshInterval = 1.0
    @AppStorage("cpuAlertThreshold") private var cpuAlertThreshold = 90.0
    @AppStorage("batteryAlertThreshold") private var batteryAlertThreshold = 80.0
    
    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    Image(systemName: "desktopcomputer")
                        .font(.title)
                        .foregroundColor(.Vitals.neonTeal)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Startup Behavior")
                            .font(.headline)
                            .foregroundColor(.Vitals.textPrimary)
                        Text("Launch Vitals automatically in the background")
                            .font(.caption)
                            .foregroundColor(.Vitals.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $launchAtLogin)
                        .toggleStyle(SwitchToggleStyle(tint: .Vitals.neonTeal))
                        .onChange(of: launchAtLogin) {
                            toggleLaunchAtLogin(enabled: launchAtLogin)
                        }
                }
                .padding()
                .background(Color.Vitals.cardBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                
                HStack(spacing: 16) {
                    Image(systemName: "timer")
                        .font(.title)
                        .foregroundColor(.Vitals.neonTeal)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Refresh Rate")
                            .font(.headline)
                            .foregroundColor(.Vitals.textPrimary)
                        Text("How often system data is updated")
                            .font(.caption)
                            .foregroundColor(.Vitals.textSecondary)
                    }
                    
                    Spacer()
                    
                    Picker("", selection: $refreshInterval) {
                        Text("1 Second").tag(1.0)
                        Text("2 Seconds").tag(2.0)
                        Text("5 Seconds").tag(5.0)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 120)
                }
                .padding()
                .background(Color.Vitals.cardBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                
                Spacer()
            }
            .padding(30)
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    Image(systemName: "bell.badge.fill")
                        .font(.title)
                        .foregroundColor(.Vitals.neonPink)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("System Alerts")
                            .font(.headline)
                            .foregroundColor(.Vitals.textPrimary)
                        Text("Notify when CPU or RAM exceeds safe limits")
                            .font(.caption)
                            .foregroundColor(.Vitals.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $systemAlertsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .Vitals.neonPink))
                }
                .padding()
                .background(Color.Vitals.cardBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                
                if systemAlertsEnabled {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Thresholds")
                            .font(.headline)
                            .foregroundColor(.Vitals.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("CPU Load Alert: ")
                                    .foregroundColor(.Vitals.textSecondary)
                                Text("\(Int(cpuAlertThreshold))%")
                                    .foregroundColor(.Vitals.neonPink)
                                    .bold()
                            }
                            Slider(value: $cpuAlertThreshold, in: 50...95, step: 5)
                                .accentColor(.Vitals.neonPink)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Battery Charge Alert: ")
                                    .foregroundColor(.Vitals.textSecondary)
                                Text("\(Int(batteryAlertThreshold))%")
                                    .foregroundColor(.Vitals.neonTeal)
                                    .bold()
                            }
                            Slider(value: $batteryAlertThreshold, in: 70...95, step: 5)
                                .accentColor(.Vitals.neonTeal)
                        }
                    }
                    .padding()
                    .background(Color.Vitals.cardBackground)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                }
                
                Spacer()
            }
            .padding(30)
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            
            VStack(spacing: 15) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 60))
                    .foregroundColor(.Vitals.neonTeal)
                    .shadow(color: .Vitals.neonTeal, radius: 10)
                
                Text("Vitals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.Vitals.textPrimary)
                
                Text("Version 1.0.0")
                    .foregroundColor(.Vitals.textSecondary)
                    .font(.headline)
                
                Text("A native macOS system monitor built with SwiftUI, delivering real-time hardware diagnostics in a clean, modern interface.")
                    .font(.body)
                    .foregroundColor(.Vitals.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                
                Link("View on GitHub", destination: URL(string: "https://github.com/Udean777/Vitals")!)
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(.Vitals.neonTeal)
                    .padding(.top, 10)
            }
            .padding(40)
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
        .frame(width: 500, height: 350)
    }
    
    private func toggleLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Gagal mengatur Launch At Login: \(error.localizedDescription)")
        }
    }
}
