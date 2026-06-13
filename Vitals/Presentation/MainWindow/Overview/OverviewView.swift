//
//  OverviewView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: OverviewViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 220), spacing: 16)
    ]
    
    init() {
        let container = DIContainer()
        _viewModel = StateObject(wrappedValue: OverviewViewModel(
            getDeviceInfoUseCase: container.getDeviceInfoUseCase,
            getBatteryInfoUseCase: container.getBatteryInfoUseCase,
            getNetworkStatsUseCase: container.getNetworkStatsUseCase,
            getSystemStatsUseCase: container.systemStatsUseCase
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                if let info = viewModel.deviceInfo {
                    // --- Header: Mac Info (Neon Style) ---
                    HStack(spacing: 20) {
                        Image(systemName: "macbook")
                            .font(.system(size: 40))
                            .foregroundColor(.Vitals.neonTeal)
                            .shadow(color: Color.Vitals.neonTeal.opacity(0.8), radius: 10, x: 0, y: 0)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(info.modelName)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.Vitals.textPrimary)
                            
                            HStack(spacing: 12) {
                                Circle().fill(Color.Vitals.neonPink).frame(width: 8, height: 8)
                                    .shadow(color: .Vitals.neonPink, radius: 4)
                                Text("\(String(format: "%.0f", info.totalRAM))GB Memory")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.textSecondary)
                                
                                Text("|").foregroundColor(.Vitals.textSecondary)
                                
                                Circle().fill(Color.Vitals.neonTeal).frame(width: 8, height: 8)
                                    .shadow(color: .Vitals.neonTeal, radius: 4)
                                Text("\(String(format: "%.0f", info.totalDiskSpace))GB SSD")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Small aesthetic elements
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                ForEach(0..<4) { i in
                                    Rectangle()
                                        .fill(Color.Vitals.neonPink.opacity(i == 3 ? 0.3 : 0.8))
                                        .frame(width: 6, height: 16)
                                }
                            }
                            Text("SYS_READY")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.Vitals.neonPink.opacity(0.8))
                        }
                    }
                    .padding(30)
                    .background(Color.Vitals.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.Vitals.cardBorder, lineWidth: 1)
                    )
                    .cornerRadius(16)
                    
                    
                    // --- Grid: Kartu Metrik Real-Time ---
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        // 1. Storage
                        SummaryCardView(
                            title: "Storage Available",
                            value: String(format: "%.0f GB", info.freeDiskSpace),
                            icon: "internaldrive",
                            color: .Vitals.textPrimary,
                            progress: 1.0 - (info.freeDiskSpace / info.totalDiskSpace)
                        )
                        
                        // 2. Battery
                        SummaryCardView(
                            title: "Battery Health",
                            value: viewModel.batteryInfo != nil ? "\(Int(viewModel.batteryInfo!.currentPercentage)) %" : "Calc...",
                            icon: "battery.100",
                            color: .Vitals.neonTeal,
                            progress: viewModel.batteryInfo != nil ? (viewModel.batteryInfo!.currentPercentage / 100.0) : 0.0
                        )
                        
                        // 3. Network (Download Speed)
                        SummaryCardView(
                            title: "Download Speed",
                            value: viewModel.networkInfo != nil ? "\(formatBytes(viewModel.networkInfo!.downloadSpeedBytes))/s" : "Calc...",
                            icon: "arrow.down.circle.fill",
                            color: .Vitals.neonBlue,
                            progress: 1.0 // Placeholder progress for network
                        )
                        
                        // 4. CPU Load
                        SummaryCardView(
                            title: "CPU Load",
                            value: viewModel.systemUsage != nil ? String(format: "%.1f %%", viewModel.systemUsage!.cpuLoad) : "Calc...",
                            icon: "cpu",
                            color: .Vitals.neonPink,
                            progress: viewModel.systemUsage != nil ? (viewModel.systemUsage!.cpuLoad / 100.0) : 0.0
                        )
                    }
                }
                
                Spacer()
            }
            .padding(40)
        }
        .frame(minWidth: 700, minHeight: 500)
        // Background Super Gelap
        .background(Color.Vitals.background)
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
