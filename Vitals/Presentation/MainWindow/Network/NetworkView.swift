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
        
        _viewModel = StateObject(wrappedValue: NetworkViewModel(
            getNetworkStatsUseCase: container.getNetworkStatsUseCase,
            getNetworkAppsUseCase: container.getNetworkAppsUseCase
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Network Traffic")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.Vitals.textPrimary)
                        Image(systemName: "wifi")
                            .font(.title)
                            .foregroundColor(.Vitals.neonTeal)
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color.Vitals.neonGreen).frame(width: 8, height: 8)
                            .shadow(color: .Vitals.neonGreen, radius: 4)
                        Text("Active Interface")
                            .font(.body)
                            .foregroundColor(.Vitals.neonGreen)
                    }
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 24) {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("DOWNLOAD")
                                .font(.subheadline)
                                .foregroundColor(.Vitals.textSecondary)
                                .tracking(1.5)
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.Vitals.neonPink.opacity(0.3), lineWidth: 1)
                                .background(Color.Vitals.neonPink.opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.Vitals.neonPink)
                                )
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            let components = viewModel.downloadSpeedString.split(separator: " ")
                            let number = components.first ?? "0"
                            let unit = components.count > 1 ? String(components[1]) : "B/s"
                            
                            Text(String(number))
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(.Vitals.neonPink)
                                .contentTransition(.numericText())
                            
                            Text(unit)
                                .font(.title3)
                                .foregroundColor(.Vitals.textSecondary)
                        }
                        
                        GeometryReader { geo in
                            let width = geo.size.width
                            let height = geo.size.height
                            let history = viewModel.downloadHistory
                            let maxVal = max(viewModel.maxDownload, 1.0)
                            let step = width / CGFloat(max(history.count - 1, 1))
                            
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: height))
                                for (index, value) in history.enumerated() {
                                    let x = CGFloat(index) * step
                                    let normalizedY = height - (CGFloat(value / maxVal) * height)
                                    path.addLine(to: CGPoint(x: x, y: normalizedY))
                                }
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.closeSubpath()
                            }
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.Vitals.neonPink.opacity(0.4), Color.clear]),
                                                 startPoint: .top, endPoint: .bottom))
                            .overlay(
                                Path { path in
                                    for (index, value) in history.enumerated() {
                                        let x = CGFloat(index) * step
                                        let normalizedY = height - (CGFloat(value / maxVal) * height)
                                        if index == 0 { path.move(to: CGPoint(x: x, y: normalizedY)) }
                                        else { path.addLine(to: CGPoint(x: x, y: normalizedY)) }
                                    }
                                }
                                    .stroke(Color.Vitals.neonPink, lineWidth: 2)
                            )
                        }
                    }
                    .padding(24)
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(16)
                    .clipped()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("UPLOAD")
                                .font(.subheadline)
                                .foregroundColor(.Vitals.textSecondary)
                                .tracking(1.5)
                            Spacer()
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.Vitals.neonTeal.opacity(0.3), lineWidth: 1)
                                .background(Color.Vitals.neonTeal.opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.Vitals.neonTeal)
                                )
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            let components = viewModel.uploadSpeedString.split(separator: " ")
                            let number = components.first ?? "0"
                            let unit = components.count > 1 ? String(components[1]) : "B/s"
                            
                            Text(String(number))
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(.Vitals.neonTeal)
                                .contentTransition(.numericText())
                            
                            Text(unit)
                                .font(.title3)
                                .foregroundColor(.Vitals.textSecondary)
                        }
                        
                        GeometryReader { geo in
                            let width = geo.size.width
                            let height = geo.size.height
                            let history = viewModel.uploadHistory
                            let maxVal = max(viewModel.maxUpload, 1.0)
                            let step = width / CGFloat(max(history.count - 1, 1))
                            
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: height))
                                for (index, value) in history.enumerated() {
                                    let x = CGFloat(index) * step
                                    let normalizedY = height - (CGFloat(value / maxVal) * height)
                                    path.addLine(to: CGPoint(x: x, y: normalizedY))
                                }
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.closeSubpath()
                            }
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.Vitals.neonTeal.opacity(0.4), Color.clear]),
                                                 startPoint: .top, endPoint: .bottom))
                            .overlay(
                                Path { path in
                                    for (index, value) in history.enumerated() {
                                        let x = CGFloat(index) * step
                                        let normalizedY = height - (CGFloat(value / maxVal) * height)
                                        if index == 0 { path.move(to: CGPoint(x: x, y: normalizedY)) }
                                        else { path.addLine(to: CGPoint(x: x, y: normalizedY)) }
                                    }
                                }
                                    .stroke(Color.Vitals.neonTeal, lineWidth: 2)
                            )
                        }
                    }
                    .padding(24)
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(16)
                    .clipped()
                }
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.down.circle")
                            Text("TOTAL DOWNLOADED")
                        }
                        .font(.caption)
                        .foregroundColor(.Vitals.textSecondary)
                        .tracking(1)
                        
                        Text(viewModel.totalDownloadedString)
                            .font(.title2).fontWeight(.bold)
                            .foregroundColor(.Vitals.neonPink)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.up.circle")
                            Text("TOTAL UPLOADED")
                        }
                        .font(.caption)
                        .foregroundColor(.Vitals.textSecondary)
                        .tracking(1)
                        
                        Text(viewModel.totalUploadedString)
                            .font(.title2).fontWeight(.bold)
                            .foregroundColor(.Vitals.neonTeal)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(12)
                }
                
                HStack(alignment: .top, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.Vitals.textSecondary)
                            Text("NETWORK DETAILS")
                                .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            NetworkDetailRow(title: "SSID", value: viewModel.ssid)
                            Divider().background(Color.Vitals.cardBorder)
                            NetworkDetailRow(title: "Local IP", value: viewModel.localIP)
                            Divider().background(Color.Vitals.cardBorder)
                            NetworkDetailRow(title: "Public IP", value: "Hidden (Privacy)")
                            Divider().background(Color.Vitals.cardBorder)
                            NetworkDetailRow(title: "Interface", value: "en0")
                        }
                    }
                    .padding(24)
                    .frame(width: 250)
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Active Network Processes")
                                .font(.title3).fontWeight(.bold).foregroundColor(.Vitals.textPrimary)
                            Spacer()
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.Vitals.textSecondary)
                        }
                        .padding(20)
                        
                        HStack {
                            Text("APP").frame(maxWidth: .infinity, alignment: .leading)
                            Text("DOWN").frame(width: 80, alignment: .trailing)
                            Text("UP").frame(width: 80, alignment: .trailing)
                        }
                        .font(.caption).foregroundColor(.Vitals.textSecondary).tracking(1)
                        .padding(.horizontal, 20).padding(.bottom, 10)
                        
                        Divider().background(Color.Vitals.cardBorder)
                        
                        VStack(spacing: 0) {
                            if viewModel.activeApps.isEmpty {
                                Text("Analyzing traffic...")
                                    .font(.caption).foregroundColor(.Vitals.textSecondary).padding(.vertical, 20)
                            } else {
                                ForEach(Array(viewModel.activeApps.enumerated()), id: \.element.id) { index, app in
                                    let colors: [Color] = [.Vitals.neonPink, .Vitals.neonTeal, .Vitals.neonYellow]
                                    let color = colors[index % colors.count]
                                    
                                    NetworkAppRow(
                                        name: app.name,
                                        down: formatNetworkBytes(app.bytesIn),
                                        up: formatNetworkBytes(app.bytesOut),
                                        color: color
                                    )
                                    
                                    if index < viewModel.activeApps.count - 1 {
                                        Divider().background(Color.Vitals.cardBorder)
                                    }
                                }
                            }
                        }
                    }
                    .background(Color.Vitals.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Vitals.cardBorder, lineWidth: 1))
                    .cornerRadius(16)
                }
                
                Spacer()
            }
            .padding(40)
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color.Vitals.background)
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
    
    func formatNetworkBytes(_ bytes: Double) -> String {
        let mb = bytes / 1_048_576.0
        if mb > 1024 { return String(format: "%.1f GB", mb / 1024.0) }
        if mb >= 1.0 { return String(format: "%.1f MB", mb) }
        return String(format: "%.0f KB", bytes / 1024.0)
    }
}

struct NetworkDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.Vitals.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.Vitals.textPrimary)
        }
    }
}

struct NetworkAppRow: View {
    let name: String
    let down: String
    let up: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "app.fill")
                    .foregroundColor(color)
                Text(name)
                    .foregroundColor(.Vitals.textPrimary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(down)
                .frame(width: 80, alignment: .trailing)
                .foregroundColor(.Vitals.neonPink)
                .font(.system(.body, design: .monospaced))
            
            Text(up)
                .frame(width: 80, alignment: .trailing)
                .foregroundColor(.Vitals.neonTeal)
                .font(.system(.body, design: .monospaced))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
    }
}
