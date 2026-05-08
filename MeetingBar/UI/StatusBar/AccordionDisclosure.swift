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
            HStack(spacing: 8) {
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.glanceInk2)
                Text("\(count) \(label)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.glanceInk2)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Rectangle().fill(hovered ? Color.mbHover(scheme) : .clear)
            )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
