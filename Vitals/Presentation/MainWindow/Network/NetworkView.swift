//
//  NetworkView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: NetworkViewModel
    
    init() {
        let container = DIContainer()
        
        _viewModel = StateObject(wrappedValue: NetworkViewModel(getNetworkStatsUseCase: container.getNetworkStatsUseCase))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Network & Connectivity")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                            
                            Text("Download")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(viewModel.downloadSpeedString)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                            .padding(.vertical, 5)
                            .contentTransition(.numericText())
                        
                        Text("Total received: \(viewModel.totalDownloadedString)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                            
                            Text("Upload")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(viewModel.uploadSpeedString)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .contentTransition(.numericText())
                        
                        Text("Total sent: \(viewModel.totalUploadedString)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding(30)
        }
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
}
