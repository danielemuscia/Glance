//
//  HelperFunctionsTests.swift
//  MeetingBarTests
//
//  Created by Andrii Leitsius on 10.04.2022.
//  Copyright © 2022 Andrii Leitsius. All rights reserved.
//

import XCTest

@testable import MeetingBar

class HelperFunctionsTests: XCTestCase {
    func test_cleanupOutlookSafeLinks_withSafeLink_returnCleanLink() throws {
        let safeLink = "https://nam12.safelinks.protection.outlook.com/ap/t-59584e83/?url=https%3A%2F%2Fteams.microsoft.com%2Fl%2Fmeetup-join%2F19%253ameeting_[obfuscated]&data=[obfuscated]"
        let cleanLink = "https://teams.microsoft.com/l/meetup-join/19%3ameeting_[obfuscated]&data=[obfuscated]"

        let result = cleanupOutlookSafeLinks(rawText: safeLink)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, cleanLink)
    }

    func test_cleanupOutlookSafeLinks_witoutSafeLink_returnInput() throws {
        let input = "https://zoom.us/j/5551112222"
        let result = cleanupOutlookSafeLinks(rawText: input)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, input)
    }

    func test_getMatch_withMatch_returnMatch() throws {
        let regex = try! NSRegularExpression(pattern: #"[0-9]{2}"#)
        let result = getMatch(text: "0.11.22.match", regex: regex)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "11")
    }

    func test_getMatch_withoutMatch_returnNil() throws {
        let regex = try! NSRegularExpression(pattern: #"[0-9]{2}"#)
        let result = getMatch(text: "0.1one1.2two2.match", regex: regex)
        XCTAssertNil(result)
    }

    func test_cleanUpNotes_inputHTML_returnClean() throws {
        let rawNotes = "<p>description</p>"

        let result = cleanUpNotes(rawNotes)
        XCTAssertEqual(result, "description\n")
    }

    func test_cleanUpNotes_inputMeetDivider_returnClean() throws {
        let rawNotes = """
        description
        ──────────
        under divider
        """

        let result = cleanUpNotes(rawNotes)
        XCTAssertEqual(result, "description")
    }

    func test_cleanUpNotes_inputZoomDivider_returnClean() throws {
        let rawNotes = """
        description
        -::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-
        under divider
        """

        let result = cleanUpNotes(rawNotes)
        XCTAssertEqual(result, "description\n")
    }

    func test_hexStringToUIColor() throws {
        let result = hexStringToUIColor(hex: "#FFFF00")
        XCTAssertEqual(result, NSColor.yellow)
    }

    // MARK: - compareVersions

    func test_compareVersions_higherFirst_returnsTrue() {
        XCTAssertTrue(compareVersions("2.0.0", "1.9.9"))
    }

    func test_compareVersions_lowerFirst_returnsFalse() {
        XCTAssertFalse(compareVersions("1.0.0", "2.0.0"))
    }

    func test_compareVersions_equal_returnsFalse() {
        XCTAssertFalse(compareVersions("1.0.0", "1.0.0"))
    }

    func test_compareVersions_numericalNotLexicographic() {
        // "10.0" > "9.99" numerically but not lexicographically
        XCTAssertTrue(compareVersions("10.0", "9.99"))
    }

    // MARK: - Data(base64URL:)

    func test_base64URL_decodesSimpleString() {
        // "Hello" in base64 is "SGVsbG8=" but without padding in base64url: "SGVsbG8"
        let data = Data(base64URL: "SGVsbG8")
        XCTAssertNotNil(data)
        XCTAssertEqual(String(data: data!, encoding: .utf8), "Hello")
    }

    func test_base64URL_convertsHyphenToPlus() {
        // base64url uses "-" instead of "+"
        // "Hello World" in base64 is "SGVsbG8gV29ybGQ="
        let data = Data(base64URL: "SGVsbG8gV29ybGQ")
        XCTAssertNotNil(data)
        XCTAssertEqual(String(data: data!, encoding: .utf8), "Hello World")
    }

    func test_base64URL_returnsNilForInvalidInput() {
        let data = Data(base64URL: "!!!not-valid!!!")
        XCTAssertNil(data)
    }

    // MARK: - generateFakeEvent

    func test_generateFakeEvent_returnsEventWithZoomLink() {
        let event = generateFakeEvent()
        XCTAssertEqual(event.id, "test_event")
        XCTAssertEqual(event.title, "Test event")
        XCTAssertNotNil(event.meetingLink)
        XCTAssertEqual(event.meetingLink?.service, .zoom)
    }

    // MARK: - getInstallationDate

    func test_getInstallationDate_returnsDate() {
        // The Documents folder always exists, so this should return a non-nil date
        let date = getInstallationDate()
        XCTAssertNotNil(date)
    }
}
