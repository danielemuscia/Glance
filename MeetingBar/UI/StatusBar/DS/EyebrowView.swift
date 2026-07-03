import SwiftUI

enum EyebrowStyle {
    case live      // dot fill glanceAccent · text glanceAccentText
    case neutral   // dot stroke glanceInk2 · text glanceInk2
    case danger    // dot fill glanceDanger · text glanceDanger
}

struct EyebrowView: View {
    let text: String
    let style: EyebrowStyle

    var body: some View {
        HStack(spacing: Space.sm) {
            dot
            Text(text)
                .font(Typography.eyebrow)
                .tracking(0.5)
                .foregroundColor(textColor)
        }
    }

    @ViewBuilder
    private var dot: some View {
        switch style {
        case .live:
            Circle()
                .fill(Color.glanceAccent)
                .frame(width: 8, height: 8)
        case .neutral:
            Circle()
                .stroke(Color.glanceInk2.opacity(0.45), lineWidth: 1)
                .frame(width: 8, height: 8)
        case .danger:
            Circle()
                .fill(Color.glanceDanger)
                .frame(width: 8, height: 8)
        }
    }

    private var textColor: Color {
        switch style {
        case .live: return Color.glanceAccentText
        case .neutral: return Color.glanceInk2
        case .danger: return Color.glanceDanger
        }
    }
}
