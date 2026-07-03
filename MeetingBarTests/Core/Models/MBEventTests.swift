//
//  MBEventTests.swift
//  MeetingBarTests
//

import XCTest
import Defaults
@testable import MeetingBar

final class MBEventTests: BaseTestCase {

    private let calendar = MBCalendar(title: "Test Calendar", id: "cal1", source: nil, email: "user@example.com", color: .black)

    // MARK: - All-day promotion

    func test_init_midnightToMidnight_isPromotedToAllDay() {
        let day = Calendar.current.startOfDay(for: Date())
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: day)!

        let event = MBEvent(
            id: "1", lastModifiedDate: nil, title: "Midnight Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: day, endDate: nextDay,
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertTrue(event.isAllDay, "Event from midnight to midnight should be promoted to all-day")
    }

    func test_init_nonMidnightTimes_isNotPromotedToAllDay() {
        let start = Date()
        let end = start.addingTimeInterval(3600)

        let event = MBEvent(
            id: "2", lastModifiedDate: nil, title: "Regular Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: start, endDate: end,
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertFalse(event.isAllDay)
    }

    // MARK: - Title fallback

    func test_init_nilTitle_usesLocalisedNoTitleKey() {
        let event = MBEvent(
            id: "3", lastModifiedDate: nil, title: nil,
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertEqual(event.title, "status_bar_no_title".loco())
    }

    func test_init_nonNilTitle_keepsTitleAsIs() {
        let event = MBEvent(
            id: "4", lastModifiedDate: nil, title: "My Meeting",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertEqual(event.title, "My Meeting")
    }

    // MARK: - participationStatus from attendees

    func test_init_currentUserAttendee_setsParticipationStatus() {
        let attendees = [
            MBEventAttendee(email: "user@example.com", name: "Me", status: .accepted, isCurrentUser: true),
            MBEventAttendee(email: "other@example.com", name: "Other", status: .declined, isCurrentUser: false)
        ]

        let event = MBEvent(
            id: "5", lastModifiedDate: nil, title: "Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: attendees,
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertEqual(event.participationStatus, .accepted)
    }

    func test_init_noCurrentUserAttendee_defaultsToUnknown() {
        let attendees = [
            MBEventAttendee(email: "other@example.com", name: "Other", status: .declined, isCurrentUser: false)
        ]

        let event = MBEvent(
            id: "6", lastModifiedDate: nil, title: "Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: attendees,
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertEqual(event.participationStatus, .unknown)
    }

    // MARK: - meetingLink priority (location > url > notes)

    func test_init_locationHasLink_usesLocationLink() {
        let event = MBEvent(
            id: "7", lastModifiedDate: nil, title: "Event",
            status: .confirmed,
            notes: "Join via https://zoom.us/j/9999",
            location: "https://zoom.us/j/1111",
            url: URL(string: "https://zoom.us/j/2222"),
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertNotNil(event.meetingLink)
        XCTAssertTrue(event.meetingLink!.url.absoluteString.contains("1111"),
                      "Location link should take priority over url and notes")
    }

    func test_init_noLocationLink_urlHasLink_usesUrlLink() {
        let event = MBEvent(
            id: "8", lastModifiedDate: nil, title: "Event",
            status: .confirmed,
            notes: "Join via https://zoom.us/j/9999",
            location: "Conference Room A",
            url: URL(string: "https://zoom.us/j/2222"),
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertNotNil(event.meetingLink)
        XCTAssertTrue(event.meetingLink!.url.absoluteString.contains("2222"),
                      "URL field should take priority over notes when location has no link")
    }

    func test_init_noLocationOrUrl_notesHasLink_usesNotesLink() {
        let event = MBEvent(
            id: "9", lastModifiedDate: nil, title: "Event",
            status: .confirmed,
            notes: "Join via https://zoom.us/j/9999",
            location: nil,
            url: nil,
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertNotNil(event.meetingLink)
        XCTAssertEqual(event.meetingLink?.service, .zoom)
    }

    func test_init_noLinksAnywhere_meetingLinkIsNil() {
        let event = MBEvent(
            id: "10", lastModifiedDate: nil, title: "Event",
            status: .confirmed,
            notes: "Just a regular note",
            location: "Room 101",
            url: URL(string: "https://example.com/not-a-meeting"),
            organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendar
        )

        XCTAssertNil(event.meetingLink)
    }

    // MARK: - Google Meet authuser append

    func test_init_meetLink_withCalendarEmail_appendsAuthuser() {
        let calendarWithEmail = MBCalendar(title: "Work Cal", id: "work", source: nil, email: "user@example.com", color: .black)

        let event = MBEvent(
            id: "11", lastModifiedDate: nil, title: "Meet Call",
            status: .confirmed, notes: nil,
            location: "https://meet.google.com/abc-defg-hij",
            url: nil, organizer: nil, attendees: [],
            startDate: Date(), endDate: Date().addingTimeInterval(3600),
            isAllDay: false, recurrent: false, calendar: calendarWithEmail
        )

        XCTAssertNotNil(event.meetingLink)
        XCTAssertEqual(event.meetingLink?.service, .meet)
        XCTAssertTrue(event.meetingLink!.url.absoluteString.contains("authuser="),
                      "Google Meet link should contain authuser parameter when calendar has email")
    }

    // MARK: - getEventDateString

    func test_getEventDateString_militaryFormat_returns24HourString() {
        Defaults[.timeFormat] = .military

        let start = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15, hour: 14, minute: 30))!
        let end = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15, hour: 15, minute: 0))!

        let event = MBEvent(
            id: "12", lastModifiedDate: nil, title: "Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: start, endDate: end,
            isAllDay: false, recurrent: false, calendar: calendar
        )

        let result = getEventDateString(event)
        XCTAssertTrue(result.contains("14:30"), "Military format should show 14:30")
        XCTAssertTrue(result.contains("15:00"), "Military format should show 15:00")
    }

    func test_getEventDateString_amPmFormat_returns12HourString() {
        Defaults[.timeFormat] = .am_pm

        let start = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15, hour: 14, minute: 30))!
        let end = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15, hour: 15, minute: 0))!

        let event = MBEvent(
            id: "13", lastModifiedDate: nil, title: "Event",
            status: .confirmed, notes: nil, location: nil, url: nil,
            organizer: nil, attendees: [],
            startDate: start, endDate: end,
            isAllDay: false, recurrent: false, calendar: calendar
        )

        let result = getEventDateString(event)
        // 14:30 in 12-hour is 2:30 PM
        let containsPM = result.contains("PM") || result.contains("pm") || result.contains("2:30")
        XCTAssertTrue(containsPM, "AM/PM format should show afternoon time in 12-hour format")
    }
}
