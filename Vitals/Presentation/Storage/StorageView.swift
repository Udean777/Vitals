//
//  StorageView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct StorageView: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: StorageViewModel
    
    init() {
        let container = DIContainer()
        _viewModel = StateObject(wrappedValue: StorageViewModel(getDeviceInfoUseCase: container.getDeviceInfoUseCase))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Storage Analyzer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 50) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 35)
                            .foregroundColor(.green.opacity(0.2))
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(viewModel.usedDisk / viewModel.totalDisk))
                            .stroke(style: StrokeStyle(lineWidth: 35, lineCap: .butt))
                            .foregroundColor(.blue)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeOut(duration: 1.5), value: viewModel.usedDisk)
                        
                        VStack {
                            Text(String(format: "%.0f GB", viewModel.totalDisk))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                            
                            Text("Total SSD")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 220, height: 220)
                    .padding(20)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.blue).frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text("Used Space").font(.headline)
                                
                                Text(String(format: "%.1f GB", viewModel.usedDisk))
                                    .font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.green.opacity(0.2)).frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text("Free Space").font(.headline)
                                
                                Text(String(format: "%.1f GB", viewModel.freeDisk))
                                    .font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Junk & Cache Scanner")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Fitur pemindai *developer cache* (seperti Xcode DerivedData atau Gradle Cache) akan dikembangkan nanti, karena membutuhkan layar onboarding khusus untuk meminta perizinan privasi *Full Disk Access* dari macOS.")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange.opacity(0.4), lineWidth: 1))
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(30)
        }
    }
}
