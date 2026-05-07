// Glance.swift — drop-in brand tokens
// Pair with the existing Color.mb* utilities in DesignTokens.swift.
import SwiftUI

extension Color {
    // Brand accent — lifted in dark for AA contrast
    static let glanceAccent     = Color.dynamic(light: 0x2C5CFF, dark: 0x7FA0FF)
    static let glanceAccentText = Color.dynamic(light: 0x1F47CC, dark: 0x9DB6FF)

    // Informational
    static let glanceSuccess = Color.dynamic(light: 0x1A8A45, dark: 0x5BD37F)
    static let glanceWarning = Color.dynamic(light: 0xB25E00, dark: 0xFFB454)
    static let glanceDanger  = Color.dynamic(light: 0xC8201A, dark: 0xFF6961)

    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(NSColor(name: nil, dynamicProvider: { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(hex: isDark ? dark : light)
        }))
    }
}

extension NSColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8)  & 0xFF) / 255
        let b = CGFloat( hex        & 0xFF) / 255
        self.init(srgbRed: r, green: g, blue: b, alpha: 1)
    }
}
