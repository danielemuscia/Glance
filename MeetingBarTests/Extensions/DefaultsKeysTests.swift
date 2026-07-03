//
//  DefaultsKeysTests.swift
//  MeetingBarTests
//

import XCTest
import Defaults
@testable import MeetingBar

// Schema regression tests for critical Defaults keys.
// If a default value changes accidentally, these tests catch it.
final class DefaultsKeysTests: BaseTestCase {

    // MARK: - Notification defaults (safety: must default to true)

    func test_joinEventNotification_defaultIsTrue() {
        XCTAssertTrue(Defaults[.joinEventNotification])
    }

    func test_endOfEventNotification_defaultIsTrue() {
        XCTAssertTrue(Defaults[.endOfEventNotification])
    }

    // MARK: - Security: intrusive features must default to false

    func test_fullscreenNotification_defaultIsFalse() {
        XCTAssertFalse(Defaults[.fullscreenNotification],
                       "Fullscreen notification must default to false to avoid surprising users")
    }

    func test_automaticEventJoin_defaultIsFalse() {
        XCTAssertFalse(Defaults[.automaticEventJoin],
                       "Auto-join must default to false")
    }

    // MARK: - Collection defaults (must be empty)

    func test_selectedCalendarIDs_defaultIsEmpty() {
        XCTAssertTrue(Defaults[.selectedCalendarIDs].isEmpty)
    }

    func test_dismissedEvents_defaultIsEmpty() {
        XCTAssertTrue(Defaults[.dismissedEvents].isEmpty)
    }

    func test_filterEventRegexes_defaultIsEmpty() {
        XCTAssertTrue(Defaults[.filterEventRegexes].isEmpty)
    }

    func test_bookmarks_defaultIsEmpty() {
        XCTAssertTrue(Defaults[.bookmarks].isEmpty)
    }

    func test_processedEventsForFullscreenNotification_defaultIsEmpty() {
        XCTAssertTrue(Defaults[.processedEventsForFullscreenNotification].isEmpty)
    }

    // MARK: - Enum defaults

    func test_eventTitleFormat_defaultIsShow() {
        XCTAssertEqual(Defaults[.eventTitleFormat], .show)
    }

    func test_showEventsForPeriod_defaultIsToday() {
        XCTAssertEqual(Defaults[.showEventsForPeriod], .today)
    }

    func test_declinedEventsAppereance_defaultIsStrikethrough() {
        XCTAssertEqual(Defaults[.declinedEventsAppereance], .strikethrough)
    }

    func test_hideMeetingTitle_defaultIsFalse() {
        XCTAssertFalse(Defaults[.hideMeetingTitle])
    }

    // MARK: - ProcessedEvent round-trip

    func test_dismissedEvents_roundTrip() {
        let event = ProcessedEvent(id: "test-123", lastModifiedDate: Date(timeIntervalSince1970: 1000), eventEndDate: Date(timeIntervalSince1970: 2000))
        Defaults[.dismissedEvents] = [event]

        let retrieved = Defaults[.dismissedEvents]
        XCTAssertEqual(retrieved.count, 1)
        XCTAssertEqual(retrieved[0].id, "test-123")
        XCTAssertEqual(retrieved[0].eventEndDate.timeIntervalSince1970, 2000, accuracy: 0.001)
    }
}
