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
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        let container = DIContainer()
        
        _viewModel = StateObject(wrappedValue: OverviewViewModel(getDeviceInfoUseCase: container.getDeviceInfoUseCase))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("System Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let info = viewModel.deviceInfo {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "macbook")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(info.hostName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(info.modelName)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Divider()
                        HStack(spacing: 40) {
                            VStack(alignment: .leading) {
                                Text("Memory").font(.caption).foregroundColor(.secondary)
                                Text(String(format: "%.0f GB", info.totalRAM)).font(.headline)
                            }
                            VStack(alignment: .leading) {
                                Text("macOS Version").font(.caption).foregroundColor(.secondary)
                                Text(info.osVersion).font(.headline)
                            }
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Text("At a Glance")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        SummaryCardView(
                            title: "Free Storage",
                            value: String(format: "%.1f GB / %.0f GB", info.freeDiskSpace, info.totalDiskSpace),
                            icon: "internaldrive",
                            color: .green
                        )
                        
                        SummaryCardView(
                            title: "System Temperature",
                            value: "Phase 3 (TBD)",
                            icon: "thermometer",
                            color: .orange
                        )
                        
                        SummaryCardView(
                            title: "Battery Health",
                            value: "Phase 3 (TBD)",
                            icon: "battery.100",
                            color: .blue
                        )
                        
                        SummaryCardView(
                            title: "Swap Memory",
                            value: "Phase 4 (TBD)",
                            icon: "memorychip",
                            color: .purple
                        )
                    }
                }
                
                Spacer()
            }
            .padding(30)
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}
