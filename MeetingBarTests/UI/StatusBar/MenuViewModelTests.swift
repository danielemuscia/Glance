//
//  MenuViewModelTests.swift
//  MeetingBarTests
//

import XCTest
@testable import MeetingBar

// Note: Uses setUp() async throws so that @MainActor properties can be safely
// mutated — XCTest calls setUp() async throws on the main actor for @MainActor classes.
@MainActor
final class MenuViewModelTests: BaseTestCase {

    private var vm: MenuViewModel!

    override func setUp() async throws {
        // BaseTestCase.setUp() is called separately by XCTest before this.
        vm = MenuViewModel()
    }

    override func tearDown() async throws {
        vm = nil
        // BaseTestCase.tearDown() is called separately by XCTest after this.
    }

    // MARK: - selectedEvent

    func test_selectedEvent_whenSelectedEventIdIsNil_returnsNil() {
        vm.events = [makeFakeEvent(id: "A", start: Date(), end: Date().addingTimeInterval(3600))]
        vm.selectedEventId = nil

        XCTAssertNil(vm.selectedEvent)
    }

    func test_selectedEvent_whenIdMatches_returnsCorrectEvent() {
        let e = makeFakeEvent(id: "B", start: Date(), end: Date().addingTimeInterval(3600))
        vm.events = [e]
        vm.selectedEventId = "B"

        XCTAssertEqual(vm.selectedEvent?.id, "B")
    }

    func test_selectedEvent_whenIdDoesNotMatch_returnsNil() {
        vm.events = [makeFakeEvent(id: "C", start: Date(), end: Date().addingTimeInterval(3600))]
        vm.selectedEventId = "nonexistent"

        XCTAssertNil(vm.selectedEvent)
    }

    func test_selectedEvent_whenEventsAreEmpty_returnsNil() {
        vm.events = []
        vm.selectedEventId = "anyId"

        XCTAssertNil(vm.selectedEvent)
    }

    // MARK: - Callbacks (nil by default, not crashing)

    func test_joinNextMeeting_withNilCallback_doesNotCrash() {
        vm.onJoinNext = nil
        XCTAssertNoThrow(vm.joinNextMeeting())
    }

    func test_createMeeting_withNilCallback_doesNotCrash() {
        vm.onCreateMeeting = nil
        XCTAssertNoThrow(vm.createMeeting())
    }

    func test_openPreferences_withNilCallback_doesNotCrash() {
        vm.onOpenPreferences = nil
        XCTAssertNoThrow(vm.openPreferences())
    }

    func test_reload_withNilCallback_doesNotCrash() {
        vm.onReload = nil
        XCTAssertNoThrow(vm.reload())
    }

    // MARK: - Callbacks fire correctly

    func test_joinNextMeeting_callsOnJoinNext() {
        var called = false
        vm.onJoinNext = { called = true }
        vm.joinNextMeeting()
        XCTAssertTrue(called)
    }

    func test_createMeeting_callsOnCreateMeeting() {
        var called = false
        vm.onCreateMeeting = { called = true }
        vm.createMeeting()
        XCTAssertTrue(called)
    }

    func test_openPreferences_callsOnOpenPreferences() {
        var called = false
        vm.onOpenPreferences = { called = true }
        vm.openPreferences()
        XCTAssertTrue(called)
    }

    func test_reload_callsOnReload() {
        var called = false
        vm.onReload = { called = true }
        vm.reload()
        XCTAssertTrue(called)
    }
}
