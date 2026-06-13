import SwiftUI

extension Color {
    enum Vitals {
        // MARK: - Latar Belakang (Backgrounds)
        static let background = Color(red: 0.05, green: 0.05, blue: 0.07)
        static let cardBackground = Color.black.opacity(0.4)
        static let cardBorder = Color.white.opacity(0.1)
        
        // MARK: - Aksen Neon (Neon Accents)
        static let neonPink = Color(red: 1.0, green: 0.0, blue: 0.5)
        static let neonTeal = Color(red: 0.0, green: 0.9, blue: 0.8)
        static let neonYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
        static let neonBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
        static let neonGreen = Color(red: 0.2, green: 0.9, blue: 0.2)
        
        // MARK: - Teks (Typography)
        static let textPrimary = Color.white
        static let textSecondary = Color.gray
    }
}
