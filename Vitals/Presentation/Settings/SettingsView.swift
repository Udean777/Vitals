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
                
                Text("NeonOS Vitals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.Vitals.textPrimary)
                
                Text("Version 2.0.4-TOKYO")
                    .foregroundColor(.Vitals.neonPink)
                    .font(.caption)
                    .tracking(1)
                
                Text("Cyberpunk system monitor built with SwiftUI.")
                    .font(.caption)
                    .foregroundColor(.Vitals.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            .padding(40)
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
        .frame(width: 500, height: 300)
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
