import SwiftUI

extension Color {
    enum Vitals {
        static let background = Color(red: 0.96, green: 0.96, blue: 0.98)
        static let cardBackground = Color.white
        static let cardBorder = Color.black.opacity(0.08)
        
        static let neonPink = Color(red: 0.95, green: 0.25, blue: 0.45)
        static let neonTeal = Color(red: 0.15, green: 0.65, blue: 0.70)
        static let neonYellow = Color(red: 0.90, green: 0.55, blue: 0.05)
        static let neonBlue = Color(red: 0.10, green: 0.45, blue: 0.90)
        static let neonGreen = Color(red: 0.20, green: 0.75, blue: 0.35)
        static let neonPurple = Color(red: 0.50, green: 0.30, blue: 0.80)
        
        static let textPrimary = Color.black.opacity(0.85)
        static let textSecondary = Color.black.opacity(0.55)
    }
}
