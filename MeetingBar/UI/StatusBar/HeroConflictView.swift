import SwiftUI
import Defaults

struct HeroConflictView: View {
    let events: [MBEvent]
    var onSelect: (String) -> Void
    var onJoin: (MBEvent) -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: Space.md) {
            EyebrowView(text: "CONFLICT · \(events.count) MEETINGS NOW", style: .danger)
            Text("Pick one to join.")
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
            VStack(spacing: Space.sm) {
                ForEach(events) { event in
                    card(for: event)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.xxl)
    }

    private func card(for event: MBEvent) -> some View {
        HStack(alignment: .top, spacing: Space.sm) {
            ServiceMarkView(service: event.meetingLink?.service, size: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(Typography.subhead)
                    .foregroundColor(.glanceInk1)
                    .lineLimit(1)
                Text(metaString(for: event))
                    .font(Typography.captionMono)
                    .foregroundColor(.glanceInk2)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            if event.meetingLink != nil {
                Button { onJoin(event) } label: {
                    Text("Join")
                        .font(Typography.body)
                        .foregroundColor(.white)
                        .padding(.vertical, Space.sm)
                        .padding(.horizontal, Space.lg)
                        .background(Color.glanceAccent)
                        .cornerRadius(Radius.md)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Space.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.lg).fill(Color.mbHeroBg(scheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.mbStroke(scheme), lineWidth: 0.5)
        )
        .contentShape(Rectangle())
        .onTapGesture { onSelect(event.id) }
    }

    private func metaString(for event: MBEvent) -> String {
        let formatter = DateFormatter()
        formatter.locale = I18N.instance.locale
        formatter.dateFormat = Defaults[.timeFormat] == .am_pm ? "h:mm a" : "HH:mm"
        let range = "\(formatter.string(from: event.startDate)) – \(formatter.string(from: event.endDate))"
        var parts = [range]
        if let service = event.meetingLink?.service?.rawValue {
            parts.append(service)
        }
        if !event.attendees.isEmpty {
            parts.append("\(event.attendees.count) \(event.attendees.count == 1 ? "attendee" : "attendees")")
        }
        return parts.joined(separator: " · ")
    }
}
