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
            VStack(alignment: .leading, spacing: 30) {
                Text("Compute & Memory")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 40) {
                    VStack(spacing: 12) {
                        Gauge(value: viewModel.cpuLoad, in: 0...100) {
                            Text("CPU")
                        } currentValueLabel: {
                            Text(String(format: "%.0f%%", viewModel.cpuLoad))
                                .font(.system(.title3, design: .rounded))
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(Gradient(colors: [.green, .orange, .red]))
                        .scaleEffect(2.0)
                        .padding(30)
                        
                        Text("Processor Load")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unified Memory")
                            .font(.headline)
                        
                        ProgressView(value: viewModel.usedRAM, total: viewModel.totalRAM)
                            .progressViewStyle(.linear)
                            .tint(.purple)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        
                        HStack {
                            Text(String(format: "%.1f GB Used", viewModel.usedRAM))
                                .font(.caption).foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f GB Total", viewModel.totalRAM))
                                .font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(40)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Text("Live Processes (Top 10)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("PID").frame(width: 60, alignment: .leading)
                        Text("Name").frame(maxWidth: .infinity, alignment: .leading)
                        Text("% CPU").frame(width: 80, alignment: .trailing)
                        Text("% RAM").frame(width: 80, alignment: .trailing)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color(NSColor.windowBackgroundColor))
                    
                    Divider()
                    
                    ForEach(viewModel.topProcess) {process in
                        HStack {
                            Text("\(process.pid)")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.secondary)
                                .font(.system(.body, design: .monospaced))
                            
                            Text(process.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            
                            Text(String(format: "%.1f", process.cpuUsage))
                                .frame(width: 80, alignment: .trailing)
                                .foregroundColor(process.cpuUsage > 50 ? .red : .primary)
                                .font(.system(.body, design: .monospaced))
                            
                            Text(String(format: "%.1f", process.ramUsage))
                                .frame(width: 80, alignment: .trailing)
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        
                        Divider()
                    }
                }
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Spacer()
            }
            .padding(30)
        }
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
}
