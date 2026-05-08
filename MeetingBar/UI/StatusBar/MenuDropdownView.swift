import SwiftUI

struct MenuDropdownView: View {
    let events: [MBEvent]
    @Binding var selectedEventId: String?

    var onCreateMeeting: () -> Void
    var onPreferences: () -> Void

    @State private var earlierExpanded = false
    @State private var moreExpanded = false

    private var state: PanelState { PanelState.from(events: events) }

    var body: some View {
        VStack(spacing: 0) {
            BrandStripView(events: events)
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .noCalendar:
            EmptyStateView(
                kind: .noCalendarConnected,
                primaryAction: ("Open Preferences", onPreferences)
            )

        case .empty:
            HeroEmptyView()

        case .wrappedUp(let past):
            VStack(spacing: 0) {
                EarlierTodayList(events: past, expanded: $earlierExpanded) { selectedEventId = $0 }
                HeroWrappedView(doneCount: past.count)
            }

        case .between(let next, let past, let more):
            VStack(spacing: 0) {
                EarlierTodayList(events: past, expanded: $earlierExpanded) { selectedEventId = $0 }
                HeroBetweenView(next: next)
                betweenList(next: next, more: more)
            }

        case .live(let event, let past, let more):
            VStack(spacing: 0) {
                EarlierTodayList(events: past, expanded: $earlierExpanded) { selectedEventId = $0 }
                HeroLiveView(
                    event: event,
                    mode: .live,
                    onSelect: { selectedEventId = event.id },
                    onJoin: { event.openMeeting() }
                )
                MoreTodayList(events: more, expanded: $moreExpanded) { selectedEventId = $0 }
            }

        case .nextSoon(let event, let past, let more):
            VStack(spacing: 0) {
                EarlierTodayList(events: past, expanded: $earlierExpanded) { selectedEventId = $0 }
                HeroLiveView(
                    event: event,
                    mode: .nextSoon,
                    onSelect: { selectedEventId = event.id },
                    onJoin: { event.openMeeting() }
                )
                MoreTodayList(events: more, expanded: $moreExpanded) { selectedEventId = $0 }
            }

        case .conflict(let nowEvents, let past, let more):
            VStack(spacing: 0) {
                EarlierTodayList(events: past, expanded: $earlierExpanded) { selectedEventId = $0 }
                HeroConflictView(
                    events: nowEvents,
                    onSelect: { selectedEventId = $0 },
                    onJoin: { $0.openMeeting() }
                )
                MoreTodayList(events: more, expanded: $moreExpanded) { selectedEventId = $0 }
            }
        }
    }

    /// Between has a special list shape: when the count of upcoming events is 1
    /// (just the `next`), the list is collapsed-by-default into a single peek row;
    /// when there are multiple upcoming events we surface them as a normal MoreTodayList
    /// where the first row carries the inline NEXT label.
    @ViewBuilder
    private func betweenList(next: MBEvent, more: [MBEvent]) -> some View {
        let upcoming = [next] + more
        MoreTodayList(events: upcoming, expanded: $moreExpanded) { selectedEventId = $0 }
    }
}
