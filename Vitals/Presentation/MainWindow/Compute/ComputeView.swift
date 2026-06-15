//
//  ComputeView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct ComputeView: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: ComputeViewModel
    
    init() {
        let container = DIContainer()
        _viewModel = StateObject(wrappedValue: ComputeViewModel(
            systemStatsUseCase: container.systemStatsUseCase,
            getTopProcessesUseCase: container.getTopProcessesUseCase
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compute & Unified Memory")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.Vitals.textPrimary)
                    Text("System Resource Distribution Engine")
                        .font(.body)
                        .foregroundColor(.Vitals.textSecondary)
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundColor(.Vitals.neonPink)
                            Text("CPU LOAD")
                                .font(.subheadline)
                                .foregroundColor(.Vitals.textSecondary)
                                .tracking(1.5)
                            Spacer()
                            Text("Apple Silicon").font(.caption).padding(4).background(Color.Vitals.neonPink.opacity(0.2)).foregroundColor(.Vitals.neonPink).cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        HStack {
                            ZStack {
                                Circle().stroke(Color.Vitals.neonPink.opacity(0.2), lineWidth: 10)
                                Circle().trim(from: 0, to: viewModel.cpuLoad / 100.0)
                                    .stroke(Color.Vitals.neonPink, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .shadow(color: .Vitals.neonPink, radius: 5)
                                VStack {
                                    Text(String(format: "%.0f%%", viewModel.cpuLoad))
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.Vitals.textPrimary)
                                    Text("LOAD").font(.caption2).foregroundColor(.Vitals.textSecondary)
                                }
                            }
                            .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 30))
                                path.addLine(to: CGPoint(x: 20, y: 25))
                                path.addLine(to: CGPoint(x: 40, y: 40))
                                path.addLine(to: CGPoint(x: 60, y: 20))
                                path.addLine(to: CGPoint(x: 80, y: 10))
                                path.addLine(to: CGPoint(x: 100, y: 35))
                                path.addLine(to: CGPoint(x: 120, y: 25))
                            }
                            .stroke(Color.Vitals.neonPink, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .frame(width: 120, height: 50)
                            .shadow(color: .Vitals.neonPink, radius: 2)
                        }
                    }
                    .padding(24)
                    .frame(height: 180)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.neonPink.opacity(0.3), lineWidth: 1))
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "memorychip")
                                .foregroundColor(.Vitals.neonTeal)
                            Text("MEMORY ENGINE")
                                .font(.subheadline)
                                .foregroundColor(.Vitals.textSecondary)
                                .tracking(1.5)
                            Spacer()
                            Text("Unified").font(.caption).padding(4).background(Color.Vitals.neonTeal.opacity(0.2)).foregroundColor(.Vitals.neonTeal).cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        HStack {
                            ZStack {
                                Circle().stroke(Color.Vitals.neonTeal.opacity(0.2), lineWidth: 10)
                                let ramPercent = viewModel.totalRAM > 0 ? (viewModel.usedRAM / viewModel.totalRAM) : 0
                                Circle().trim(from: 0, to: ramPercent)
                                    .stroke(Color.Vitals.neonTeal, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .shadow(color: .Vitals.neonTeal, radius: 5)
                                VStack {
                                    Text(String(format: "%.0f%%", ramPercent * 100))
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.Vitals.textPrimary)
                                    Text("USED").font(.caption2).foregroundColor(.Vitals.textSecondary)
                                }
                            }
                            .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Circle().fill(Color.Vitals.neonTeal).frame(width: 8, height: 8)
                                    Text("ACTIVE HARDWARE").font(.caption).foregroundColor(.Vitals.neonTeal).tracking(1)
                                }
                                Text("Allocation")
                                    .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                                Text("System caching and\napp memory pipelines\nengaged.")
                                    .font(.caption)
                                    .foregroundColor(.Vitals.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(24)
                    .frame(height: 180)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.neonTeal.opacity(0.3), lineWidth: 1))
                    .cornerRadius(16)
                }
                
                HStack(spacing: 24) {
                    HStack {
                        Image(systemName: "thermometer.sun.fill")
                            .font(.title)
                            .foregroundColor(.Vitals.neonYellow)
                        VStack(alignment: .leading) {
                            Text("THERMAL SENSORS")
                                .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                            HStack(spacing: 12) {
                                Text(viewModel.thermalState)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(viewModel.thermalState == "Normal" ? .Vitals.textPrimary : .Vitals.neonPink)
                                Text("SMC Locked")
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.Vitals.neonTeal)
                        VStack(alignment: .leading) {
                            Text("SWAP MEMORY USAGE")
                                .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                            HStack(spacing: 12) {
                                Text(String(format: "%.1f GB", viewModel.swapUsed))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.Vitals.textPrimary)
                                Text(viewModel.swapUsed > 0 ? "Active" : "Inactive")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(viewModel.swapUsed > 0 ? Color.Vitals.neonPink.opacity(0.2) : Color.Vitals.neonGreen.opacity(0.2))
                                    .foregroundColor(viewModel.swapUsed > 0 ? .Vitals.neonPink : .Vitals.neonGreen)
                                    .cornerRadius(4)
                            }
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Unified Memory Breakdown")
                                .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                            Text(String(format: "%.0f GB Total Physical Memory", viewModel.totalRAM))
                                .font(.caption).foregroundColor(.Vitals.textSecondary)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text(String(format: "Swap Memory: %.1f GB", 0.0))
                        }
                        .font(.caption).foregroundColor(.Vitals.neonTeal)
                        .padding(8).background(Color.Vitals.cardBorder).cornerRadius(8)
                    }
                    
                    GeometryReader { geo in
                        let total = max(viewModel.totalRAM, 1)
                        let appW = CGFloat(viewModel.appMemory / total) * geo.size.width
                        let wiredW = CGFloat(viewModel.wiredMemory / total) * geo.size.width
                        let compW = CGFloat(viewModel.compressedMemory / total) * geo.size.width
                        let cacheW = CGFloat(viewModel.cachedFiles / total) * geo.size.width
                        
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.Vitals.neonPink).frame(width: max(appW, 0))
                            Rectangle().fill(Color.Vitals.neonYellow).frame(width: max(wiredW, 0))
                            Rectangle().fill(Color.Vitals.neonTeal).frame(width: max(compW, 0))
                            Rectangle().fill(Color(red: 0.3, green: 0.2, blue: 0.4)).frame(width: max(cacheW, 0))
                            Rectangle().fill(Color.Vitals.cardBorder)
                        }
                        .cornerRadius(8)
                    }
                    .frame(height: 20)
                    .animation(.linear(duration: 0.5), value: viewModel.usedRAM)
                    
                    HStack(spacing: 20) {
                        LegendItem(color: .Vitals.neonPink, label: "App Memory", value: viewModel.appMemory)
                        LegendItem(color: .Vitals.neonYellow, label: "Wired", value: viewModel.wiredMemory)
                        LegendItem(color: .Vitals.neonTeal, label: "Compressed", value: viewModel.compressedMemory)
                        LegendItem(color: Color(red: 0.3, green: 0.2, blue: 0.4), label: "Cached", value: viewModel.cachedFiles)
                        Spacer()
                        Text(String(format: "%.1f GB", viewModel.totalRAM - viewModel.usedRAM))
                            .font(.caption).foregroundColor(.Vitals.textSecondary)
                    }
                }
                .padding(24)
                .background(Color.Vitals.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Active Resource Table")
                            .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                        Spacer()
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.Vitals.textSecondary)
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.Vitals.textSecondary)
                    }
                    .padding(20)
                    
                    HStack {
                        Text("PROCESS NAME").frame(maxWidth: .infinity, alignment: .leading)
                        Text("CPU (%)").frame(width: 80, alignment: .trailing)
                        Text("MEMORY").frame(width: 100, alignment: .trailing)
                        Text("PID").frame(width: 60, alignment: .trailing)
                    }
                    .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                    .padding(.horizontal, 20).padding(.bottom, 10)
                    
                    Divider().background(Color.Vitals.cardBorder)
                    
                    ForEach(viewModel.topProcess) { process in
                        HStack {
                            HStack(spacing: 12) {
                                Image(systemName: "square.fill")
                                    .foregroundColor(process.cpuUsage > 20 ? .Vitals.neonPink : .Vitals.neonTeal)
                                    .font(.system(size: 10))
                                Text(process.name)
                                    .foregroundColor(.Vitals.textPrimary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(format: "%.1f", process.cpuUsage))
                                .frame(width: 80, alignment: .trailing)
                                .foregroundColor(process.cpuUsage > 20 ? .Vitals.neonPink : .Vitals.textSecondary)
                                .font(.system(.body, design: .monospaced))
                            
                            Text(String(format: "%.1f MB", process.ramUsage))
                                .frame(width: 100, alignment: .trailing)
                                .foregroundColor(process.ramUsage > 500 ? .Vitals.neonYellow : .Vitals.textSecondary)
                                .font(.system(.body, design: .monospaced))
                            
                            Text("\(process.pid)")
                                .frame(width: 60, alignment: .trailing)
                                .foregroundColor(.Vitals.textSecondary)
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        
                        Divider().background(Color.Vitals.cardBorder)
                    }
                }
                .background(Color.Vitals.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                .cornerRadius(16)
                
                Spacer()
            }
            .padding(40)
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color.Vitals.background)
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    let value: Double
    
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
                .shadow(color: color.opacity(0.8), radius: 2)
            Text(label).font(.caption).foregroundColor(.Vitals.textPrimary)
            Text(String(format: "%.1f GB", value)).font(.caption).foregroundColor(.Vitals.neonPink)
        }
    }
}
