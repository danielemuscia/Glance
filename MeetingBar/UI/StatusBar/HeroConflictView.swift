import SwiftUI
import Defaults

struct HeroConflictView: View {
    let events: [MBEvent]
    var onSelect: (String) -> Void
    var onJoin: (MBEvent) -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            eyebrow
            Text("Pick one to join.")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.glanceInk1)
            VStack(spacing: 8) {
                ForEach(events) { event in
                    card(for: event)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
    }

    private var eyebrow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.glanceDanger)
                .frame(width: 8, height: 8)
            Text("CONFLICT · \(events.count) MEETINGS NOW")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.5)
                .foregroundColor(.glanceDanger)
        }
    }

    private func card(for event: MBEvent) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ServiceMarkView(service: event.meetingLink?.service, size: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.glanceInk1)
                    .lineLimit(1)
                Text(metaString(for: event))
                    .font(.system(size: 11.5).monospacedDigit())
                    .foregroundColor(.glanceInk2)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            if event.meetingLink != nil {
                Button { onJoin(event) } label: {
                    Text("Join")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 14)
                        .background(Color.glanceAccent)
                        .cornerRadius(7)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10).fill(Color.mbHeroBg(scheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
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
