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
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        SummaryCardView(
                            title: "Storage Available",
                            value: String(format: "%.0f GB", info.freeDiskSpace),
                            icon: "internaldrive",
                            color: .Vitals.textPrimary,
                            progress: 1.0 - (info.freeDiskSpace / info.totalDiskSpace)
                        )
                        
                        SummaryCardView(
                            title: "Battery Health",
                            value: viewModel.batteryInfo != nil ? "\(Int(viewModel.batteryInfo!.currentPercentage)) %" : "Calc...",
                            icon: "battery.100",
                            color: .Vitals.neonTeal,
                            progress: viewModel.batteryInfo != nil ? (viewModel.batteryInfo!.currentPercentage / 100.0) : 0.0
                        )
                        
                        SummaryCardView(
                            title: "Download Speed",
                            value: viewModel.networkInfo != nil ? "\(formatBytes(viewModel.networkInfo!.downloadSpeedBytes))/s" : "Calc...",
                            icon: "arrow.down.circle.fill",
                            color: .Vitals.neonBlue,
                            progress: 1.0
                        )
                        
                        SummaryCardView(
                            title: "CPU Load",
                            value: viewModel.systemUsage != nil ? String(format: "%.1f %%", viewModel.systemUsage!.cpuLoad) : "Calc...",
                            icon: "cpu",
                            color: .Vitals.neonPink,
                            progress: viewModel.systemUsage != nil ? (viewModel.systemUsage!.cpuLoad / 100.0) : 0.0
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("SYSTEM QUICK ACTIONS")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.Vitals.textSecondary)
                            .tracking(2)
                            .padding(.top, 20)
                        
                        HStack(spacing: 20) {
                            QuickActionButton(icon: "memorychip", title: "Free Up RAM", color: .Vitals.neonPink)
                            QuickActionButton(icon: "trash", title: "Scan Cache", color: .Vitals.neonYellow)
                            QuickActionButton(icon: "bolt.batteryblock", title: "Low Power", color: .Vitals.neonTeal)
                        }
                    }
                    
                    HStack {
                        SpecBadge(title: "Architecture", value: "ARM64 (Apple Silicon)")
                        Spacer()
                        SpecBadge(title: "OS Build", value: "macOS 14.x")
                        Spacer()
                        SpecBadge(title: "Total Cores", value: "8 Cores")
                    }
                    .padding(20)
                    .background(Color.Vitals.cardBackground)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding(40)
        }
        .frame(minWidth: 700, minHeight: 500)
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

struct QuickActionButton: View {
    var icon: String
    var title: String
    var color: Color
    @State private var isHovered = false
    @State private var isExecuting = false
    @State private var isDone = false
    
    var body: some View {
        Button(action: {
            guard !isExecuting else { return }
            isExecuting = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isExecuting = false
                isDone = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isDone = false
                }
            }
        }) {
            HStack(spacing: 12) {
                if isExecuting {
                    ProgressView()
                        .scaleEffect(0.7)
                        .tint(color)
                } else {
                    Image(systemName: isDone ? "checkmark" : icon)
                        .font(.system(size: 16))
                        .foregroundColor(isDone ? .green : color)
                        .shadow(color: isHovered ? color : .clear, radius: 5)
                }
                
                Text(isExecuting ? "Executing..." : (isDone ? "Done!" : title))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isDone ? .green : .Vitals.textPrimary)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(Color.Vitals.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isDone ? Color.green : (isHovered ? color.opacity(0.5) : Color.Vitals.cardBorder), lineWidth: 1)
            )
            .shadow(color: isHovered && !isDone ? color.opacity(0.2) : .clear, radius: 10)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
}

struct SpecBadge: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.Vitals.textSecondary)
                .tracking(1)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.Vitals.textPrimary)
        }
    }
}
