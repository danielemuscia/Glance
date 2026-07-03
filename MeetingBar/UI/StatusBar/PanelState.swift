import Foundation
import Defaults

enum PanelState {
    case noCalendar
    case conflict(now: [MBEvent], past: [MBEvent], more: [MBEvent])
    case live(event: MBEvent, past: [MBEvent], more: [MBEvent])
    case nextSoon(event: MBEvent, past: [MBEvent], more: [MBEvent])
    case between(next: MBEvent, past: [MBEvent], more: [MBEvent])
    case wrappedUp(past: [MBEvent])
    case empty
}

extension PanelState {
    /// Filters used by both PanelState and BrandStripView so dots/summary stay in sync.
    static func panelEvents(from events: [MBEvent], now: Date) -> [MBEvent] {
        events
            .filter { !$0.isAllDay }
            .filter { isVisible($0, now: now) }
            .sorted { $0.startDate < $1.startDate }
    }

    static func from(events: [MBEvent], now: Date = Date()) -> PanelState {
        if Defaults[.selectedCalendarIDs].isEmpty {
            return .noCalendar
        }

        let panelEvents = panelEvents(from: events, now: now)

        let nowEvents = panelEvents.filter { $0.startDate <= now && $0.endDate > now }
        let pastEvents = panelEvents.filter { $0.endDate <= now }
        let upcoming = panelEvents.filter { $0.startDate > now }

        if nowEvents.count >= 2 {
            return .conflict(now: nowEvents, past: pastEvents, more: upcoming)
        }

        if let live = nowEvents.first {
            return .live(event: live, past: pastEvents, more: upcoming)
        }

        let threshold = nextSoonThreshold()
        if let next = upcoming.first, next.startDate.timeIntervalSince(now) <= threshold {
            return .nextSoon(event: next, past: pastEvents, more: Array(upcoming.dropFirst()))
        }

        if let next = upcoming.first {
            return .between(next: next, past: pastEvents, more: Array(upcoming.dropFirst()))
        }

        if !pastEvents.isEmpty {
            return .wrappedUp(past: pastEvents)
        }

        return .empty
    }

    private static func nextSoonThreshold() -> TimeInterval {
        if Defaults[.showEventMaxTimeUntilEventEnabled] {
            return TimeInterval(Defaults[.showEventMaxTimeUntilEventThreshold] * 60)
        }
        return 600
    }

    private static func isVisible(_ event: MBEvent, now: Date) -> Bool {
        if (event.participationStatus == .declined || event.status == .canceled),
           Defaults[.declinedEventsAppereance] == .hide {
            return false
        }
        if event.endDate < now, Defaults[.pastEventsAppereance] == .hide {
            return false
        }
        if event.attendees.isEmpty, Defaults[.personalEventsAppereance] == .hide {
            return false
        }
        return true
    }
}

extension PanelState {
    var totalToday: Int {
        switch self {
        case .noCalendar, .empty: return 0
        case .wrappedUp(let past): return past.count
        case .conflict(let now, let past, let more): return now.count + past.count + more.count
        case .live(_, let past, let more): return 1 + past.count + more.count
        case .nextSoon(_, let past, let more): return 1 + past.count + more.count
        case .between(_, let past, let more): return 1 + past.count + more.count
        }
    }

    var doneCount: Int {
        switch self {
        case .noCalendar, .empty: return 0
        case .wrappedUp(let past): return past.count
        case .conflict(_, let past, _),
             .live(_, let past, _),
             .nextSoon(_, let past, _),
             .between(_, let past, _):
            return past.count
        }
    }
}
