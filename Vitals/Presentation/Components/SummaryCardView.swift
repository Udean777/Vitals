//
//  SummaryCardView.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import SwiftUI

struct SummaryCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    // Optional progress for the bottom bar (0.0 to 1.0)
    var progress: Double = 0.5 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.Vitals.textSecondary)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .bold))
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                // We extract the numeric part and string part if needed, but for simplicity, 
                // we'll just show the value big. If value contains space (e.g. "45° C"), we could split it, 
                // but let's just make the whole text large and bold.
                Text(value)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(color)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Progress Bar at the bottom
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.15))
                        .frame(height: 4)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(progress), height: 4)
                        .shadow(color: color.opacity(0.8), radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: 4)
        }
        .padding(20)
        // Dark glass background from AppTheme
        .background(Color.Vitals.cardBackground)
        // Border
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Vitals.cardBorder, lineWidth: 1)
        )
        .cornerRadius(16)
        .frame(height: 120)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
