import SwiftUI

struct BrandStripView: View {
    let events: [MBEvent]
    @Environment(\.colorScheme) private var scheme

    private var counts: DayCounts { DayCounts.from(events: events, now: Date()) }

    var body: some View {
        HStack(spacing: 8) {
            wordmark
            Spacer()
            HStack(spacing: 10) {
                Text(daySummary)
                    .font(.system(size: 11.5).monospacedDigit())
                    .foregroundColor(.glanceInk2)
                if counts.total > 0 {
                    progressView
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.mbStrokeSoft(scheme))
                .frame(height: 0.5)
        }
    }

    private var wordmark: some View {
        HStack(alignment: .center, spacing: 6) {
            Text("Glance")
                .font(.system(size: 13, weight: .semibold))
                .tracking(-0.26)
                .foregroundColor(.glanceInk1)
            Circle()
                .fill(Color.glanceAccent)
                .frame(width: 4, height: 4)
        }
    }

    @ViewBuilder
    private var progressView: some View {
        switch counts.mode {
        case .perMeeting:
            DotRowView(done: counts.done, active: counts.active, upcoming: counts.upcoming)
        case .perHour:
            DotRowView(done: counts.doneH, active: counts.activeH, upcoming: counts.upH)
        case .counter:
            CounterBarView(done: counts.done, total: counts.total, scheme: scheme)
        }
    }

    private var daySummary: String {
        let formatter = DateFormatter()
        formatter.locale = I18N.instance.locale
        formatter.dateFormat = "EEE, MMM d"
        let dateStr = formatter.string(from: Date())
        if counts.total == 0 {
            return "\(dateStr) · No meetings"
        }
        let noun = counts.total == 1 ? "meeting" : "meetings"
        return "\(dateStr) · \(counts.total) \(noun)"
    }
}

// MARK: - Dot Row

struct DotRowView: View {
    let done: Int
    let active: Int
    let upcoming: Int
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<done, id: \.self) { _ in
                Circle()
                    .fill(Color.glanceInk1.opacity(0.85))
                    .frame(width: 6, height: 6)
            }
            ForEach(0..<active, id: \.self) { _ in
                ZStack {
                    Circle()
                        .fill(Color.glanceAccent.opacity(0.18))
                        .frame(width: 11, height: 11)
                    Circle()
                        .fill(Color.glanceAccent)
                        .frame(width: 7, height: 7)
                }
            }
            ForEach(0..<upcoming, id: \.self) { _ in
                Circle()
                    .stroke(Color.mbText3(scheme), lineWidth: 1)
                    .frame(width: 6, height: 6)
            }
        }
    }
}

// MARK: - Counter + Bar

struct CounterBarView: View {
    let done: Int
    let total: Int
    let scheme: ColorScheme

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 0) {
                Text("\(done)")
                    .fontWeight(.semibold)
                    .foregroundColor(.glanceInk1)
                Text(" / \(total)")
                    .foregroundColor(.glanceInk2)
            }
            .font(.system(size: 11.5).monospacedDigit())

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.mbStroke(scheme))
                    .frame(width: 60, height: 3)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.glanceAccent)
                    .frame(width: 60 * CGFloat(done) / CGFloat(max(total, 1)), height: 3)
            }
        }
    }
}

// MARK: - Day Counts

struct DayCounts {
    enum Mode { case perMeeting, perHour, counter }

    let total: Int
    let done: Int
    let active: Int
    let upcoming: Int
    let doneH: Int
    let activeH: Int
    let upH: Int

    var mode: Mode {
        switch total {
        case ...8: return .perMeeting
        case 9...12: return .perHour
        default: return .counter
        }
    }

    static func from(events: [MBEvent], now: Date) -> DayCounts {
        let total = events.count
        let done = events.filter { $0.endDate < now }.count
        let active = events.contains { $0.startDate <= now && now < $0.endDate } ? 1 : 0
        let upcoming = max(0, total - done - active)

        let cal = Calendar.current
        let hours = Set(events.map { cal.component(.hour, from: $0.startDate) }).sorted()
        let doneH = hours.filter { hr in
            events.filter { cal.component(.hour, from: $0.startDate) == hr }
                  .allSatisfy { $0.endDate < now }
        }.count
        let activeH = hours.contains { hr in
            events.contains { ev in
                cal.component(.hour, from: ev.startDate) == hr
                    && ev.startDate <= now && now < ev.endDate
            }
        } ? 1 : 0
        let upH = max(0, min(9, hours.count) - doneH - activeH)

        return DayCounts(
            total: total,
            done: done, active: active, upcoming: upcoming,
            doneH: doneH, activeH: activeH, upH: upH
        )
    }
}
