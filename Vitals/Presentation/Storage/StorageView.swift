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
        
        _viewModel = StateObject(wrappedValue: StorageViewModel(
            getDeviceInfoUseCase: container.getDeviceInfoUseCase,
            checkFDAUseCase: container.checkFDAUseCase,
            scanDeveloperCachesUseCase: container.scanDeveloperCachesUseCase,
            scanLargeFilesUseCase: container.scanLargeFilesUseCase
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Storage Analyzer")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.Vitals.textPrimary)
                        Image(systemName: "internaldrive.fill")
                            .font(.title)
                            .foregroundColor(.Vitals.neonTeal)
                    }
                    Text("Deep Space File System & Cleanup")
                        .font(.body)
                        .foregroundColor(.Vitals.textSecondary)
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 50) {
                    ZStack {
                        Circle()
                            .stroke(Color.Vitals.cardBorder, lineWidth: 35)
                        
                        let ratio = viewModel.totalDisk > 0 ? (viewModel.usedDisk / viewModel.totalDisk) : 0
                        Circle()
                            .trim(from: 0.0, to: CGFloat(ratio))
                            .stroke(Color.Vitals.neonTeal, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeOut(duration: 1.5), value: viewModel.usedDisk)
                            .shadow(color: .Vitals.neonTeal, radius: 10)
                        
                        VStack {
                            Text(String(format: "%.0f GB", viewModel.totalDisk))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.Vitals.textPrimary)
                            
                            Text("TOTAL SSD")
                                .font(.caption)
                                .foregroundColor(.Vitals.textSecondary)
                                .tracking(1)
                        }
                    }
                    .frame(width: 220, height: 220)
                    .padding(20)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.Vitals.neonTeal)
                                .frame(width: 24, height: 24)
                                .shadow(color: .Vitals.neonTeal, radius: 4)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("USED SPACE").font(.subheadline).foregroundColor(.Vitals.textSecondary).tracking(1)
                                Text(String(format: "%.1f GB", viewModel.usedDisk))
                                    .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                            }
                        }
                        
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.Vitals.cardBorder)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FREE SPACE").font(.subheadline).foregroundColor(.Vitals.textSecondary).tracking(1)
                                Text(String(format: "%.1f GB", viewModel.freeDisk))
                                    .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                            }
                        }
                        
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.Vitals.neonYellow)
                                .frame(width: 24, height: 24)
                                .shadow(color: .Vitals.neonYellow, radius: 4)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("PURGEABLE").font(.subheadline).foregroundColor(.Vitals.textSecondary).tracking(1)
                                Text(String(format: "%.1f GB", viewModel.purgeableDisk))
                                    .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                            }
                        }
                    }
                }
                .padding(40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Vitals.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("File Type Breakdown")
                        .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                    
                    GeometryReader { geo in
                        let safeTotal = max(viewModel.totalDisk, 1.0)
                        let usedRatio = viewModel.usedDisk / safeTotal
                        let freeRatio = viewModel.freeDisk / safeTotal
                        
                        let appsRatio = usedRatio * 0.45
                        let sysRatio = usedRatio * 0.35
                        let docsRatio = usedRatio * 0.20
                        
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.Vitals.neonTeal).frame(width: geo.size.width * CGFloat(appsRatio))
                            Rectangle().fill(Color.Vitals.neonPink).frame(width: geo.size.width * CGFloat(sysRatio))
                            Rectangle().fill(Color.Vitals.neonYellow).frame(width: geo.size.width * CGFloat(docsRatio))
                            Rectangle().fill(Color.Vitals.cardBorder).frame(width: geo.size.width * CGFloat(freeRatio))
                        }
                        .cornerRadius(8)
                    }
                    .frame(height: 16)
                    
                    HStack(spacing: 20) {
                        HStack(spacing: 6) { Circle().fill(Color.Vitals.neonTeal).frame(width: 8, height: 8); Text("Apps & Games").font(.caption).foregroundColor(.Vitals.textSecondary) }
                        HStack(spacing: 6) { Circle().fill(Color.Vitals.neonPink).frame(width: 8, height: 8); Text("System Data").font(.caption).foregroundColor(.Vitals.textSecondary) }
                        HStack(spacing: 6) { Circle().fill(Color.Vitals.neonYellow).frame(width: 8, height: 8); Text("Documents").font(.caption).foregroundColor(.Vitals.textSecondary) }
                        Spacer()
                    }
                }
                .padding(24)
                .background(Color.Vitals.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Deep Space Scanner (Dev Caches & Large Files)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.Vitals.textPrimary)
                        Spacer()
                        
                        if viewModel.hasFDA && !viewModel.isScanning && !viewModel.cacheItems.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Terdeteksi: \(viewModel.totalCacheSavedString)")
                            }
                            .font(.headline)
                            .foregroundColor(.Vitals.neonPink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.Vitals.neonPink.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    
                    if !viewModel.hasFDA {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 16) {
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.Vitals.neonYellow)
                                    .shadow(color: .Vitals.neonYellow, radius: 10)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Akses Disk Diperlukan (Full Disk Access)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.Vitals.neonYellow)
                                    Text("Vitals memerlukan izin privasi khusus untuk dapat menembus folder rahasia milik Xcode dan Android Studio.")
                                        .font(.subheadline)
                                        .foregroundColor(.Vitals.textSecondary)
                                }
                            }
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    viewModel.openPrivacySettings()
                                }) {
                                    Label("Buka Pengaturan", systemImage: "gearshape.fill")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color.Vitals.neonYellow)
                                .foregroundColor(.black)
                                
                                Button(action: {
                                    viewModel.checkFDA()
                                }) {
                                    Label("Cek Ulang Izin", systemImage: "arrow.clockwise")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                }
                                .buttonStyle(.bordered)
                                .tint(Color.Vitals.textSecondary)
                                
                                Text("(Jika di-run via Xcode, centang juga izin untuk Xcode!)")
                                    .font(.caption)
                                    .foregroundColor(.Vitals.textSecondary)
                            }
                            .padding(.top, 5)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.Vitals.neonYellow.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.neonYellow.opacity(0.3), lineWidth: 1))
                        .cornerRadius(16)
                        
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            if viewModel.isScanning {
                                HStack(spacing: 15) {
                                    ProgressView().tint(Color.Vitals.neonTeal).scaleEffect(0.8)
                                    Text("Menganalisis jutaan file developer...").foregroundColor(.Vitals.neonTeal)
                                }
                                .padding(24).frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.Vitals.cardBackground)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                                .cornerRadius(12)
                            } else if viewModel.cacheItems.isEmpty {
                                HStack {
                                    Text("Klik untuk mencari file sisa dari Xcode atau Android.")
                                        .foregroundColor(.Vitals.textSecondary)
                                    Spacer()
                                    Button(action: { viewModel.startScan() }) {
                                        Label("Scan Sekarang", systemImage: "magnifyingglass")
                                            .padding(.horizontal, 16).padding(.vertical, 8)
                                    }
                                    .buttonStyle(.borderedProminent).tint(Color.Vitals.neonTeal).foregroundColor(.black)
                                    .cornerRadius(8)
                                }
                                .padding(24).background(Color.Vitals.cardBackground)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                                .cornerRadius(12)
                            } else {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("DIRECTORY").frame(maxWidth: .infinity, alignment: .leading)
                                        Text("SIZE").frame(width: 100, alignment: .trailing)
                                    }
                                    .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                                    .padding(.horizontal, 24).padding(.vertical, 16)
                                    
                                    Divider().background(Color.Vitals.cardBorder)
                                    
                                    ForEach(viewModel.cacheItems) { item in
                                        HStack {
                                            HStack(spacing: 12) {
                                                Image(systemName: "folder.fill")
                                                    .foregroundColor(item.sizeBytes > 1_000_000_000 ? .Vitals.neonPink : .Vitals.neonTeal)
                                                Text(item.name).font(.system(.body, design: .rounded)).foregroundColor(.Vitals.textPrimary)
                                            }
                                            Spacer()
                                            Text(formatBytes(item.sizeBytes))
                                                .font(.system(.body, design: .monospaced))
                                                .foregroundColor(item.sizeBytes > 1_000_000_000 ? .Vitals.neonPink : .Vitals.textSecondary)
                                        }
                                        .padding(.vertical, 16).padding(.horizontal, 24)
                                        Divider().background(Color.Vitals.cardBorder)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: { viewModel.startScan() }) {
                                            Label("Scan Ulang", systemImage: "arrow.clockwise").font(.subheadline)
                                        }
                                        .buttonStyle(.borderless).foregroundColor(.Vitals.neonTeal).padding(16)
                                    }
                                }
                                .background(Color.Vitals.cardBackground)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("LARGE DOWNLOADS").frame(maxWidth: .infinity, alignment: .leading)
                            Text("SIZE").frame(width: 100, alignment: .trailing)
                        }
                        .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                        .padding(.horizontal, 24).padding(.vertical, 16)
                        
                        Divider().background(Color.Vitals.cardBorder)
                        
                        if viewModel.isScanningLargeFiles {
                            ProgressView().padding(.vertical, 20).frame(maxWidth: .infinity)
                        } else if viewModel.largeFiles.isEmpty {
                            Text("No large files found.")
                                .font(.caption).foregroundColor(.Vitals.textSecondary)
                                .padding(.vertical, 20).frame(maxWidth: .infinity)
                        } else {
                            ForEach(Array(viewModel.largeFiles.enumerated()), id: \.element.id) { index, file in
                                let colors: [Color] = [.Vitals.neonPink, .Vitals.neonTeal, .Vitals.neonYellow]
                                let color = colors[index % colors.count]
                                
                                StorageLargeFileRow(
                                    name: file.name,
                                    size: formatBytes(file.sizeBytes),
                                    color: color
                                )
                                
                                if index < viewModel.largeFiles.count - 1 {
                                    Divider().background(Color.Vitals.cardBorder)
                                }
                            }
                        }
                    }
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(12)
                    .padding(.top, 10)
                    
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(40)
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color.Vitals.background)
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

struct StorageLargeFileRow: View {
    let name: String
    let size: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "doc.zipper")
                    .foregroundColor(color)
                Text(name)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.Vitals.textPrimary)
                    .lineLimit(1)
            }
            Spacer()
            Text(size)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.Vitals.textSecondary)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
}
