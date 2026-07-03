//
//  ActionsOnEventStartTests.swift
//  MeetingBarTests
//

import XCTest
import Defaults
@testable import MeetingBar

// Note: Uses setUp() async throws so that @MainActor properties can be safely
// mutated — XCTest calls setUp() async throws on the main actor for @MainActor classes.
@MainActor
final class ActionsOnEventStartTests: BaseTestCase {

    private var context: FakeActionsContext!
    private var actions: ActionsOnEventStart!

    override func setUp() async throws {
        // BaseTestCase.setUp() is called separately by XCTest before this.
        context = FakeActionsContext()
        actions = ActionsOnEventStart(context)
    }

    override func tearDown() async throws {
        actions = nil
        context = nil
        // BaseTestCase.tearDown() is called separately by XCTest after this.
    }

    // MARK: - screenIsLocked guard

    func test_checkNextEvent_whenScreenIsLocked_doesNothing() {
        context.screenIsLocked = true
        context.stubbedNextEvent = makeFakeEvent(
            id: "E1",
            start: Date().addingTimeInterval(-5),
            end: Date().addingTimeInterval(600),
            withLink: true
        )

        Defaults[.fullscreenNotification] = true

        actions.checkNextEvent()

        XCTAssertTrue(context.openedFullscreenEvents.isEmpty,
                      "Should not open fullscreen notification when screen is locked")
        XCTAssertTrue(Defaults[.processedEventsForFullscreenNotification].isEmpty,
                      "Should not add to processed events when screen is locked")
    }

    // MARK: - All actions disabled guard

    func test_checkNextEvent_whenAllActionsDisabled_returnsEarly() {
        context.screenIsLocked = false
        context.stubbedNextEvent = makeFakeEvent(
            id: "E2",
            start: Date().addingTimeInterval(-5),
            end: Date().addingTimeInterval(600),
            withLink: true
        )

        Defaults[.fullscreenNotification] = false
        Defaults[.automaticEventJoin] = false
        Defaults[.runEventStartScript] = false

        actions.checkNextEvent()

        XCTAssertTrue(context.openedFullscreenEvents.isEmpty)
    }

    // MARK: - Fullscreen notification trigger

    func test_checkNextEvent_withFullscreenEnabled_andEventInWindow_opensNotification() {
        context.screenIsLocked = false

        let now = Date()
        let event = makeFakeEvent(
            id: "E3",
            start: now.addingTimeInterval(-5),   // started 5 seconds ago
            end: now.addingTimeInterval(600),
            withLink: true
        )
        context.stubbedNextEvent = event

        Defaults[.fullscreenNotification] = true
        Defaults[.fullscreenNotificationTime] = .atStart
        Defaults[.automaticEventJoin] = false
        Defaults[.runEventStartScript] = false

        actions.checkNextEvent()

        XCTAssertFalse(context.openedFullscreenEvents.isEmpty,
                       "Should open fullscreen notification for event starting now")
    }

    func test_checkNextEvent_sameEventSameModifiedDate_notOpenedTwice() {
        context.screenIsLocked = false

        let now = Date()
        let event = makeFakeEvent(
            id: "E4",
            start: now.addingTimeInterval(-5),
            end: now.addingTimeInterval(600),
            withLink: true
        )

        Defaults[.fullscreenNotification] = true
        Defaults[.fullscreenNotificationTime] = .atStart
        Defaults[.automaticEventJoin] = false
        Defaults[.runEventStartScript] = false

        // Pre-populate processed list with same event and same lastModifiedDate
        Defaults[.processedEventsForFullscreenNotification] = [
            ProcessedEvent(id: event.id, lastModifiedDate: event.lastModifiedDate, eventEndDate: event.endDate)
        ]

        context.stubbedNextEvent = event
        actions.checkNextEvent()

        XCTAssertTrue(context.openedFullscreenEvents.isEmpty,
                      "Should not re-open fullscreen notification for already-processed event")
    }

    // MARK: - Cleanup of expired events

    func test_checkNextEvent_removesExpiredEventsFromProcessedLists() {
        context.screenIsLocked = false

        let pastDate = Date().addingTimeInterval(-3600)  // 1 hour ago
        let expiredProcessed = ProcessedEvent(id: "expired", lastModifiedDate: nil, eventEndDate: pastDate)

        Defaults[.processedEventsForFullscreenNotification] = [expiredProcessed]
        Defaults[.processedEventsForAutoJoin] = [expiredProcessed]
        Defaults[.processedEventsForRunScriptOnEventStart] = [expiredProcessed]

        Defaults[.fullscreenNotification] = false
        Defaults[.automaticEventJoin] = false
        Defaults[.runEventStartScript] = false
        context.stubbedNextEvent = nil

        actions.checkNextEvent()

        XCTAssertTrue(Defaults[.processedEventsForFullscreenNotification].isEmpty,
                      "Should remove expired events from fullscreen processed list")
        XCTAssertTrue(Defaults[.processedEventsForAutoJoin].isEmpty,
                      "Should remove expired events from auto-join processed list")
        XCTAssertTrue(Defaults[.processedEventsForRunScriptOnEventStart].isEmpty,
                      "Should remove expired events from run-script processed list")
    }
}
