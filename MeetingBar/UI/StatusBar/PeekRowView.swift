import SwiftUI
import Defaults

struct PeekRowView: View {
    let event: MBEvent
    var variant: Variant = .upcoming
    var inlineLabel: String? = nil
    var onSelect: () -> Void = {}

    @Environment(\.colorScheme) private var scheme
    @State private var hovered = false

    enum Variant { case past, upcoming, conflictNow }

    private var isDeclined: Bool {
        event.participationStatus == .declined || event.status == .canceled
    }
    private var rowOpacity: Double {
        switch variant {
        case .past: return 0.55
        case .upcoming, .conflictNow: return isDeclined ? 0.55 : 1.0
        }
    }
    private var calColor: Color { Color(nsColor: event.calendar.color) }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = I18N.instance.locale
        formatter.dateFormat = Defaults[.timeFormat] == .am_pm ? "h:mm a" : "HH:mm"
        return formatter.string(from: event.startDate)
    }

    private var subtitle: String? {
        if let service = event.meetingLink?.service {
            return service.rawValue
        }
        if event.attendees.isEmpty {
            return "Solo"
        }
        return nil
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 10) {
                if let label = inlineLabel {
                    Text(label)
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(.glanceInk2)
                        .frame(width: 36, alignment: .leading)
                        .padding(.top, 2)
                } else {
                    if variant == .past {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.glanceInk2)
                            .frame(width: 36, alignment: .leading)
                            .padding(.top, 2)
                    } else {
                        Color.clear.frame(width: 36, height: 1)
                    }
                }

                Text(timeString)
                    .font(.system(size: 12, weight: .medium).monospacedDigit())
                    .foregroundColor(variant == .past ? Color.mbText3(scheme) : .glanceInk2)
                    .strikethrough(isDeclined)
                    .frame(width: 46, alignment: .leading)
                    .padding(.top, 1)

                Circle()
                    .fill(calColor)
                    .frame(width: 6, height: 6)
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.glanceInk1)
                        .strikethrough(isDeclined)
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11.5))
                            .foregroundColor(.glanceInk2)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .opacity(rowOpacity)
        }
        .buttonStyle(MenuItemStyle(isHovered: hovered, cornerRadius: 8))
        .padding(.horizontal, 6)
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
    }
}
