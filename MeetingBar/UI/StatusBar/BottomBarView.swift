import SwiftUI

struct BottomBarView: View {
    var onNewEvent: () -> Void
    var onPreferences: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 0) {
            FooterButton(label: "+ Create meeting", action: onNewEvent)
            Spacer()
            FooterButton(label: "Preferences", action: onPreferences)
        }
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.sm)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.mbStrokeSoft(scheme))
                .frame(height: 0.5)
        }
    }
}

private struct FooterButton: View {
    let label: String
    let action: () -> Void

    @State private var hovered = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Typography.body)
                .foregroundColor(hovered ? .glanceInk1 : .glanceInk2)
                .padding(.vertical, Space.xs)
                .padding(.horizontal, Space.xs)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
