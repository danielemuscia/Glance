import SwiftUI

struct BottomBarView: View {
    var onNewEvent: () -> Void
    var onPreferences: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 0) {
            FooterButton(label: "+ New event", action: onNewEvent)
            Spacer()
            FooterButton(label: "Preferences", action: onPreferences)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
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
                .font(.system(size: 12.5, weight: .medium))
                .foregroundColor(hovered ? .glanceInk1 : .glanceInk2)
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
