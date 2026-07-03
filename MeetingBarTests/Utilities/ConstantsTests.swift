//
//  ConstantsTests.swift
//  MeetingBarTests
//

import XCTest
@testable import MeetingBar

final class ConstantsTests: XCTestCase {

    // MARK: - statusbarEventTitleLengthLimits

    func test_titleLengthLimits_minLessThanMax() {
        XCTAssertLessThan(statusbarEventTitleLengthLimits.min, statusbarEventTitleLengthLimits.max)
    }

    // MARK: - NotificationEventTimeAction

    func test_notificationEventTimeAction_untilStart_durationIsZero() {
        XCTAssertEqual(NotificationEventTimeAction.untilStart.durationInSeconds, 0)
    }

    func test_notificationEventTimeAction_fiveMinutes_duration300() {
        XCTAssertEqual(NotificationEventTimeAction.fiveMinuteLater.durationInSeconds, 300)
    }

    func test_notificationEventTimeAction_tenMinutes_duration600() {
        XCTAssertEqual(NotificationEventTimeAction.tenMinuteLater.durationInSeconds, 600)
    }

    func test_notificationEventTimeAction_fifteenMinutes_duration900() {
        XCTAssertEqual(NotificationEventTimeAction.fifteenMinuteLater.durationInSeconds, 900)
    }

    func test_notificationEventTimeAction_thirtyMinutes_duration1800() {
        XCTAssertEqual(NotificationEventTimeAction.thirtyMinuteLater.durationInSeconds, 1800)
    }

    func test_notificationEventTimeAction_durationInMinsEqualsSecondsOver60() {
        let action = NotificationEventTimeAction.thirtyMinuteLater
        XCTAssertEqual(action.durationInMins, action.durationInSeconds / 60)
    }

    // MARK: - Links enum (all static URLs must be valid)

    func test_links_patreon_isValidURL() {
        XCTAssertNotNil(Links.patreon)
    }

    func test_links_github_isValidURL() {
        XCTAssertNotNil(Links.github)
    }

    func test_links_rateAppInAppStore_isValidURL() {
        XCTAssertNotNil(Links.rateAppInAppStore)
    }

    func test_links_emailMe_usesMailtoScheme() {
        XCTAssertEqual(Links.emailMe.scheme, "mailto")
    }

    // MARK: - UtilsRegex (must compile without throwing)

    func test_outlookSafeLinkRegex_compilesAndMatchesSafeLink() {
        let url = "https://nam12.safelinks.protection.outlook.com/?url=https%3A%2F%2Fzoom.us&data=x"
        let range = NSRange(url.startIndex..., in: url)
        let match = UtilsRegex.outlookSafeLinkRegex.firstMatch(in: url, range: range)
        XCTAssertNotNil(match)
    }

    func test_linkDetectionRegex_compilesAndMatchesHttpUrl() {
        let text = "Join at https://zoom.us/j/123"
        let range = NSRange(text.startIndex..., in: text)
        let match = UtilsRegex.linkDetection.firstMatch(in: text, range: range)
        XCTAssertNotNil(match)
    }

    // MARK: - Browser Codable round-trip

    func test_browser_codableRoundTrip() throws {
        let browser = Browser(name: "Safari", path: "/Applications/Safari.app", arguments: "", deletable: true)
        let data = try JSONEncoder().encode(browser)
        let decoded = try JSONDecoder().decode(Browser.self, from: data)
        XCTAssertEqual(decoded.name, "Safari")
        XCTAssertEqual(decoded.path, "/Applications/Safari.app")
    }

    // MARK: - notificationIDs

    func test_notificationIDs_eventStartsIsNonEmpty() {
        XCTAssertFalse(notificationIDs.event_starts.isEmpty)
    }

    func test_notificationIDs_eventEndsIsNonEmpty() {
        XCTAssertFalse(notificationIDs.event_ends.isEmpty)
    }

    func test_notificationIDs_startAndEndAreDifferent() {
        XCTAssertNotEqual(notificationIDs.event_starts, notificationIDs.event_ends)
    }
}
