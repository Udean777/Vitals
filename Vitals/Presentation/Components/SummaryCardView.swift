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
                Text(value)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(color)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            
            Spacer()
            
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
        .background(Color.Vitals.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Vitals.cardBorder, lineWidth: 1)
        )
        .cornerRadius(16)
        .frame(height: 120)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
