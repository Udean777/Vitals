//
//  BatteryView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

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
                Text("Battery & Power")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else if let info = viewModel.batteryInfo {
                    HStack(spacing: 50) {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 15)
                                .opacity(0.2)
                                .foregroundColor(info.isCharging ? .green : .blue)
                            
                            Circle()
                                .trim(from: 0.0, to: CGFloat(info.currentPercentage / 100.0))
                                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .foregroundColor(info.isCharging ? .green : .blue)
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.easeInOut, value: info.currentPercentage)
                            
                            VStack {
                                Text(String(format: "%.0f%%", info.currentPercentage))
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                
                                Text(info.isCharging ? "Charging" : "On Battery")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 160, height: 160)
                        
                        VStack(alignment: .leading, spacing: 18) {
                            DetailRow(title: "Battery Health", value: String(format: "%.1f%%", info.healthPercentage))
                            DetailRow(title: "Cycle Count", value: "\(info.cycleCount) cycles")
                            DetailRow(title: "Current Capacity", value: "\(info.currentCapacity) mAh")
                            DetailRow(title: "Maximum Capacity", value: "\(info.maxCapacity) mAh")
                            DetailRow(title: "Design Capacity", value: "\(info.designCapacity) mAh")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(40)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 3)
                } else {
                    ProgressView("Membaca sensor baterai...")
                }
                
                Spacer()
            }
            .padding(30)
        }
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
}


struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold)
        }
        Divider()
    }
}
