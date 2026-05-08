import SwiftUI

struct AccordionDisclosure: View {
    let count: Int
    let label: String
    @Binding var expanded: Bool

    @Environment(\.colorScheme) private var scheme
    @State private var hovered = false

    var body: some View {
        Button {
            expanded.toggle()
        } label: {
            HStack(spacing: Space.sm) {
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
                    .font(Typography.microLabel)
                    .foregroundColor(.glanceInk2)
                Text("\(count) \(label)")
                    .font(Typography.bodySmMd)
                    .foregroundColor(.glanceInk2)
                Spacer()
            }
            .padding(.vertical, Space.sm)
            .padding(.horizontal, Space.lg)
            .background(
                Rectangle().fill(hovered ? Color.mbHover(scheme) : .clear)
            )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
