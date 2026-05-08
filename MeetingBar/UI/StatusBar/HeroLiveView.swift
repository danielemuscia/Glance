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
        VStack(alignment: .leading, spacing: 10) {
            eyebrow
            Text(event.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.glanceInk1)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            metaRow
            if event.meetingLink != nil {
                joinButton
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
    }

    private var eyebrow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(eyebrowDotColor)
                .frame(width: 8, height: 8)
            Text(eyebrowText)
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.5)
                .foregroundColor(eyebrowTextColor)
        }
    }

    private var metaRow: some View {
        HStack(spacing: 8) {
            if event.meetingLink != nil {
                ServiceMarkView(service: event.meetingLink?.service, size: 22)
            }
            Text(timeRange)
                .font(.system(size: 12).monospacedDigit())
                .foregroundColor(.glanceInk2)
                .fixedSize()
            if let serviceLabel {
                Text("·").foregroundColor(Color.glanceInk2.opacity(0.5))
                Text(serviceLabel)
                    .font(.system(size: 12))
                    .foregroundColor(.glanceInk2)
            }
            if event.attendees.count > 0 {
                Text("·").foregroundColor(Color.glanceInk2.opacity(0.5))
                Text(attendeesLabel)
                    .font(.system(size: 12))
                    .foregroundColor(.glanceInk2)
            }
            Spacer(minLength: 0)
        }
        .lineLimit(1)
    }

    private var joinButton: some View {
        Button(action: onJoin) {
            HStack(spacing: 6) {
                Image(systemName: "play.fill")
                    .font(.system(size: 11, weight: .semibold))
                Text("Join meeting")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.glanceAccent)
            .cornerRadius(10)
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
            return "NEXT · IN \(mins)M"
        }
    }

    private var eyebrowDotColor: Color {
        mode == .live ? Color.glanceAccent : Color.glanceInk2
    }

    private var eyebrowTextColor: Color {
        mode == .live ? Color.glanceAccentText : Color.glanceInk2
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

    private var attendeesLabel: String {
        let count = event.attendees.count
        return "\(count) \(count == 1 ? "attendee" : "attendees")"
    }
}
