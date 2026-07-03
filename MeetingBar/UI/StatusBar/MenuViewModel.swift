// MenuViewModel.swift — Observable state that bridges AppKit → SwiftUI for the menu panel
import SwiftUI

// Status bar label state — computed by StatusBarItemController.updateTitle()
// and rendered by StatusBarLabelView in the MenuBarExtra label closure.
struct StatusBarLabel {
    var icon: NSImage? = nil
    var title: String = ""
    var time: String = ""
    var timeUnderTitle: Bool = false
}

@MainActor
final class MenuViewModel: ObservableObject {
    @Published var events: [MBEvent] = []
    @Published var selectedEventId: String? = nil
    @Published var statusBarLabel = StatusBarLabel()

    var onCreateMeeting: (() -> Void)?
    var onOpenPreferences: (() -> Void)?
    var onJoinNext: (() -> Void)?
    var onReload: (() -> Void)?

    var selectedEvent: MBEvent? {
        guard let id = selectedEventId else { return nil }
        return events.first { $0.id == id }
    }

    var hasMeetingNow: Bool {
        let now = Date()
        return events.contains { $0.startDate <= now && $0.endDate > now }
    }

    func createMeeting() { onCreateMeeting?() }
    func openPreferences() { onOpenPreferences?() }
    func joinNextMeeting() { onJoinNext?() }
    func reload() { onReload?() }
}
