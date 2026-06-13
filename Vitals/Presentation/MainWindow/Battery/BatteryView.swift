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
                // --- HEADER ---
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
                
                // 1. Kartu Indikator Utama (Level & Health)
                if let battery = viewModel.batteryInfo {
                    HStack(spacing: 24) {
                        
                        // Kartu Level Pengisian
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
                        
                        // Kartu Kesehatan Baterai (Health)
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
                
                // 2. Grafik Historis 24 Jam (Swift Charts)
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
                            // Garis Melengkung
                            LineMark(
                                x: .value("Waktu", point.timestamp),
                                y: .value("Level", point.percentage)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(Color.Vitals.neonTeal)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            // Efek Gradien di Bawah Garis (Neon Teal)
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


