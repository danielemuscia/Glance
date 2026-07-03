//
//  FakeActionsContext.swift
//  MeetingBarTests
//

import Foundation
@testable import MeetingBar

@MainActor
final class FakeActionsContext: ActionsOnEventStartContext {
    var screenIsLocked: Bool = false
    var stubbedNextEvent: MBEvent? = nil
    var openedFullscreenEvents: [MBEvent] = []

    var nextEventWithLink: MBEvent? { stubbedNextEvent }

    func openFullscreenNotificationWindow(event: MBEvent) {
        openedFullscreenEvents.append(event)
    }
}
