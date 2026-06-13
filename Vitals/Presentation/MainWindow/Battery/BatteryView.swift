//
//  BatteryView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI
import Charts

struct BatteryView: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: BatteryViewModel
    
    init() {
        let container = DIContainer()
        _viewModel = StateObject(wrappedValue: BatteryViewModel(getBatteryInfoUseCase: container.getBatteryInfoUseCase))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Battery Health & Power")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.Vitals.textPrimary)
                        Image(systemName: "bolt.batteryblock.fill")
                            .font(.title)
                            .foregroundColor(.Vitals.neonYellow)
                    }
                    Text("Power Management & Diagnostics")
                        .font(.body)
                        .foregroundColor(.Vitals.textSecondary)
                }
                .padding(.bottom, 10)
                
                if let battery = viewModel.batteryInfo {
                    HStack(spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: battery.isCharging ? "bolt.fill" : "battery.100")
                                    .foregroundColor(battery.isCharging ? .Vitals.neonGreen : .Vitals.textSecondary)
                                Text(battery.isCharging ? "Charging" : "On Battery")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.textSecondary)
                                    .tracking(1.5)
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(Int(battery.currentPercentage))")
                                    .font(.system(size: 56, weight: .bold, design: .rounded))
                                    .foregroundColor(.Vitals.textPrimary)
                                    .contentTransition(.numericText())
                                Text("%")
                                    .font(.title3)
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.Vitals.cardBorder).frame(height: 8)
                                    Capsule()
                                        .fill(battery.currentPercentage < 20 && !battery.isCharging ? Color.Vitals.neonPink : Color.Vitals.neonTeal)
                                        .frame(width: geo.size.width * CGFloat(battery.currentPercentage / 100.0), height: 8)
                                        .shadow(color: battery.currentPercentage < 20 && !battery.isCharging ? .Vitals.neonPink : .Vitals.neonTeal, radius: 4)
                                }
                            }.frame(height: 8)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.Vitals.cardBackground)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.Vitals.neonPink)
                                Text("HEALTH STATUS")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.textSecondary)
                                    .tracking(1.5)
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(Int(battery.healthPercentage))")
                                    .font(.system(size: 56, weight: .bold, design: .rounded))
                                    .foregroundColor(.Vitals.textPrimary)
                                Text("%")
                                    .font(.title3)
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                            
                            HStack {
                                Text("Charge Cycles:")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.textSecondary)
                                Text("\(battery.cycleCount)")
                                    .font(.subheadline)
                                    .foregroundColor(.Vitals.neonYellow)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 180)
                        .background(Color.Vitals.cardBackground)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                        .cornerRadius(16)
                        
                    }
                } else {
                    Text("Memuat data sensor baterai...")
                        .foregroundColor(.Vitals.textSecondary)
                }
                
                if let battery = viewModel.batteryInfo {
                    HStack(spacing: 24) {
                        DiagnosticCard(icon: "bolt.car.fill", title: "POWER DRAW", value: battery.isCharging ? "45.2 W" : "-12.5 W", subtitle: battery.isCharging ? "Supplied via USB-C" : "Discharging", color: .Vitals.neonYellow)
                        
                        DiagnosticCard(icon: "thermometer.medium", title: "TEMPERATURE", value: "34°C", subtitle: "Normal Range", color: .Vitals.neonPink)
                        
                        let condition = battery.healthPercentage > 80 ? "Normal" : "Replace Soon"
                        let conditionColor = battery.healthPercentage > 80 ? Color.Vitals.neonGreen : Color.Vitals.neonPink
                        DiagnosticCard(icon: "checkmark.seal.fill", title: "CONDITION", value: condition, subtitle: String(format: "Health: %.1f%%", battery.healthPercentage), color: conditionColor)
                        
                        DiagnosticCard(icon: "timer", title: "TIME REMAINING", value: battery.isCharging ? "1h 20m" : "4h 15m", subtitle: battery.isCharging ? "Until Full" : "Until Empty", color: .Vitals.neonTeal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Usage History (Last 24 Hours)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.Vitals.textPrimary)
                        Spacer()
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.Vitals.neonTeal)
                    }
                    
                    if viewModel.historyPoints.isEmpty {
                        Text("Belum ada data historis yang terkumpul.")
                            .foregroundColor(.Vitals.textSecondary)
                    } else {
                        Chart(viewModel.historyPoints) { point in
                            LineMark(
                                x: .value("Waktu", point.timestamp),
                                y: .value("Level", point.percentage)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(Color.Vitals.neonTeal)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            AreaMark(
                                x: .value("Waktu", point.timestamp),
                                y: .value("Level", point.percentage)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.Vitals.neonTeal.opacity(0.4), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                        .chartYScale(domain: 0...100)
                        .frame(height: 250)
                        .padding(.top, 10)
                        .chartYAxis {
                            AxisMarks(position: .leading) { _ in
                                AxisGridLine().foregroundStyle(Color.Vitals.cardBorder)
                                AxisTick().foregroundStyle(Color.Vitals.textSecondary)
                                AxisValueLabel().foregroundStyle(Color.Vitals.textSecondary)
                            }
                        }
                        .chartXAxis {
                            AxisMarks() { _ in
                                AxisGridLine().foregroundStyle(Color.Vitals.cardBorder)
                                AxisTick().foregroundStyle(Color.Vitals.textSecondary)
                                AxisValueLabel().foregroundStyle(Color.Vitals.textSecondary)
                            }
                        }
                    }
                }
                .padding(30)
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

struct DiagnosticCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.Vitals.textSecondary)
                    .tracking(1)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.Vitals.textPrimary)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.Vitals.textSecondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Vitals.cardBackground)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
        .cornerRadius(12)
    }
}
