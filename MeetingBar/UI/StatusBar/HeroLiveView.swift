import SwiftUI
import Defaults

struct HeroLiveView: View {
    enum Mode { case live, nextSoon }

    let event: MBEvent
    let mode: Mode
    var now: Date = Date()
    var onSelect: () -> Void
    var onJoin: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            EyebrowView(text: eyebrowText, style: eyebrowStyle)
            Text(event.title)
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            metaRow
            if event.meetingLink != nil {
                joinButton
                    .padding(.top, Space.xs)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.xxl)
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
    }

    private var metaRow: some View {
        HStack(spacing: Space.sm) {
            if event.meetingLink != nil {
                ServiceMarkView(service: event.meetingLink?.service, size: 22)
            }
            Text(timeRange)
                .font(Typography.bodySmMono)
                .foregroundColor(.glanceInk2)
                .fixedSize()
            if let serviceLabel {
                Text("·").foregroundColor(Color.glanceInk2.opacity(0.5))
                Text(serviceLabel)
                    .font(Typography.bodySm)
                    .foregroundColor(.glanceInk2)
            } else if let room {
                Text("·").foregroundColor(Color.glanceInk2.opacity(0.5))
                HStack(spacing: 3) {
                    Image(systemName: "mappin").font(.system(size: 10))
                    Text(room)
                }
                .font(Typography.bodySm)
                .foregroundColor(.glanceInk2)
            }
            if event.attendees.count > 0 {
                Text("·").foregroundColor(Color.glanceInk2.opacity(0.5))
                Text(attendeesLabel)
                    .font(Typography.bodySm)
                    .foregroundColor(.glanceInk2)
            }
            Spacer(minLength: 0)
        }
        .lineLimit(1)
    }

    private var joinButton: some View {
        Button(action: onJoin) {
            HStack(spacing: Space.xs + 2) {
                Image(systemName: "play.fill")
                    .font(.system(size: 11, weight: .semibold))
                Text("Join meeting")
                    .font(Typography.subhead)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Space.md)
            .background(Color.glanceAccent)
            .cornerRadius(Radius.lg)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed

    private var eyebrowText: String {
        switch mode {
        case .live:
            let mins = max(0, Int((event.endDate.timeIntervalSince(now) / 60).rounded(.up)))
            return "NOW · ENDS IN \(mins)M"
        case .nextSoon:
            let mins = max(0, Int((event.startDate.timeIntervalSince(now) / 60).rounded(.up)))
            let unit = mins == 1 ? "MINUTE" : "MINUTES"
            return "STARTING IN \(mins) \(unit)"
        }
    }

    private var eyebrowStyle: EyebrowStyle {
        mode == .live ? .live : .neutral
    }

    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.locale = I18N.instance.locale
        formatter.dateFormat = Defaults[.timeFormat] == .am_pm ? "h:mm a" : "HH:mm"
        return "\(formatter.string(from: event.startDate)) – \(formatter.string(from: event.endDate))"
    }

    private var serviceLabel: String? {
        event.meetingLink?.service?.rawValue
    }

    private var room: String? {
        guard let location = event.location?.trimmingCharacters(in: .whitespacesAndNewlines),
              !location.isEmpty else { return nil }
        return location
    }

    private var attendeesLabel: String {
        let count = event.attendees.count
        return "\(count) \(count == 1 ? "attendee" : "attendees")"
    }
}
