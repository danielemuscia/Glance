import SwiftUI

struct MoreTodayList: View {
    let events: [MBEvent]
    @Binding var expanded: Bool
    var onSelect: (String) -> Void

    var body: some View {
        if events.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                let first = events[0]
                PeekRowView(
                    event: first,
                    variant: .upcoming,
                    inlineLabel: "NEXT"
                ) {
                    onSelect(first.id)
                }
                let rest = Array(events.dropFirst())
                if !rest.isEmpty {
                    if expanded {
                        ForEach(rest) { event in
                            PeekRowView(event: event, variant: .upcoming) {
                                onSelect(event.id)
                            }
                        }
                        MoreTodayToggle(
                            label: "Show less",
                            systemImage: "chevron.up"
                        ) { expanded = false }
                    } else {
                        MoreTodayToggle(
                            label: "+ \(rest.count) more today",
                            systemImage: "chevron.right"
                        ) { expanded = true }
                    }
                }
            }
        }
    }
}

private struct MoreTodayToggle: View {
    let label: String
    let systemImage: String
    var action: () -> Void

    @Environment(\.colorScheme) private var scheme
    @State private var hovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: Space.sm) {
                Text(label)
                    .font(Typography.body)
                    .foregroundColor(.glanceInk1)
                Spacer()
                Image(systemName: systemImage)
                    .font(Typography.eyebrow)
                    .foregroundColor(.glanceInk2)
            }
            .padding(.vertical, Space.sm)
            .padding(.horizontal, Space.lg)
            .background(Rectangle().fill(hovered ? Color.mbHover(scheme) : .clear))
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
