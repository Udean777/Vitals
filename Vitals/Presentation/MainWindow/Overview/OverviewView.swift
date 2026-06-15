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
            getSystemStatsUseCase: container.systemStatsUseCase,
            getTopProcessesUseCase: container.getTopProcessesUseCase,
            exportReportUseCase: container.exportSystemReportUseCase,
            killProcessUseCase: container.killProcessUseCase,
            getDiskIOUseCase: container.getDiskIOUseCase
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                HStack {
                    Text("System Overview")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.Vitals.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.exportReport()
                    }) {
                        Label("Export Report", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.Vitals.neonTeal)
                }
                .padding(.bottom, 10)
                
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("SSD DISTRIBUTION")
                                .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                            Spacer()
                            Text(String(format: "%.1f GB Free", info.freeDiskSpace))
                                .font(.caption).bold().foregroundColor(.Vitals.neonGreen)
                        }
                        GeometryReader { geo in
                            let used = info.totalDiskSpace - info.freeDiskSpace
                            let safeTotal = max(info.totalDiskSpace, 1.0)
                            let usedRatio = used / safeTotal
                            let freeRatio = info.freeDiskSpace / safeTotal
                            
                            let appsRatio = usedRatio * 0.45
                            let sysRatio = usedRatio * 0.35
                            let docsRatio = usedRatio * 0.20
                            
                            HStack(spacing: 0) {
                                Rectangle().fill(Color.Vitals.neonTeal).frame(width: geo.size.width * CGFloat(appsRatio))
                                Rectangle().fill(Color.Vitals.neonPink).frame(width: geo.size.width * CGFloat(sysRatio))
                                Rectangle().fill(Color.Vitals.neonYellow).frame(width: geo.size.width * CGFloat(docsRatio))
                                Rectangle().fill(Color.Vitals.cardBorder).frame(width: geo.size.width * CGFloat(freeRatio))
                            }
                            .cornerRadius(6)
                        }
                        .frame(height: 12)
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 10)
                    
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
                        
                        SummaryCardView(
                            title: "Disk Read",
                            value: viewModel.diskIOStats != nil ? formatSpeed(viewModel.diskIOStats!.readSpeedBytes) : "Calc...",
                            icon: "externaldrive.badge.person.crop",
                            color: .Vitals.neonGreen,
                            progress: 1.0
                        )
                        
                        SummaryCardView(
                            title: "Disk Write",
                            value: viewModel.diskIOStats != nil ? formatSpeed(viewModel.diskIOStats!.writeSpeedBytes) : "Calc...",
                            icon: "externaldrive.badge.icloud",
                            color: .Vitals.neonYellow,
                            progress: 1.0
                        )
                        
                        SummaryCardView(
                            title: "Swap Memory",
                            value: viewModel.systemUsage != nil ? String(format: "%.1f GB", viewModel.systemUsage!.swapUsed) : "Calc...",
                            icon: "arrow.left.arrow.right",
                            color: .Vitals.neonYellow,
                            progress: viewModel.systemUsage != nil ? (viewModel.systemUsage!.swapUsed / 4.0) : 0.0
                        )
                        
                        SummaryCardView(
                            title: "Thermal State",
                            value: viewModel.systemUsage != nil ? viewModel.systemUsage!.thermalState : "Calc...",
                            icon: "thermometer.sun.fill",
                            color: viewModel.systemUsage?.thermalState == "Normal" ? .Vitals.neonGreen : .Vitals.neonPink,
                            progress: viewModel.systemUsage != nil ? (viewModel.systemUsage!.thermalState == "Normal" ? 0.2 : 0.9) :
                                0.0
                        )
                    }
                    
                    TopProcessesView(processes: viewModel.topProcesses) { pid in
                        viewModel.forceQuitProcess(pid: pid)
                    }
                    
                    HStack {
                        SpecBadge(title: "Architecture", value: info.cpuArchitecture)
                        Spacer()
                        SpecBadge(title: "OS Build", value: info.osVersion)
                        Spacer()
                        SpecBadge(title: "Total Cores", value: "\(info.totalCores) Cores")
                    }
                    .padding(16)
                    .background(Color.Vitals.cardBackground)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                }
                
                Spacer()
            }
            .padding(24)
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
    
    private func formatSpeed(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes)) + "/s"
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

struct TopProcessesView: View {
    var processes: [ProcessEntity]
    var onKillProcess: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TOP PROCESSES")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.Vitals.textSecondary)
                .tracking(1)
            
            if processes.isEmpty {
                Text("Fetching process data...")
                    .font(.subheadline)
                    .foregroundColor(.Vitals.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(processes.enumerated()), id: \.element.pid) { index, process in
                        ProcessRow(
                            name: process.name,
                            cpu: String(format: "%.1f%%", process.cpuUsage),
                            memory: formatMemory(process.ramUsage),
                            iconColor: getIconColor(for: index)
                        )
                        .contextMenu {
                            Button(role: .destructive) {
                                onKillProcess(process.pid)
                            } label: {
                                Label("Force Quit", systemImage: "xmark.octagon")
                            }
                        }
                        
                        if index < processes.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.Vitals.cardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
    }
    
    private func formatMemory(_ kilobytes: Double) -> String {
        let mb = kilobytes / 1024.0
        if mb > 1024 {
            return String(format: "%.1f GB", mb / 1024.0)
        }
        return String(format: "%.0f MB", mb)
    }
    
    private func getIconColor(for index: Int) -> Color {
        let colors: [Color] = [.Vitals.neonPink, .Vitals.neonTeal, .Vitals.neonYellow]
        return colors[index % colors.count]
    }
    
    struct ProcessRow: View {
        var name: String
        var cpu: String
        var memory: String
        var iconColor: Color
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "app.fill")
                            .foregroundColor(iconColor)
                            .font(.system(size: 14))
                    )
                
                Text(name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.Vitals.textPrimary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(cpu)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                    
                    Text("CPU")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.Vitals.textSecondary)
                }
                .frame(width: 60, alignment: .trailing)
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(memory)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.Vitals.neonTeal)
                    Text("RAM")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.Vitals.textSecondary)
                }
                .frame(width: 70, alignment: .trailing)
            }
        }
    }
}


