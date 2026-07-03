//
//  KeychainTests.swift
//  MeetingBarTests
//

import XCTest
@testable import MeetingBar

final class KeychainTests: XCTestCase {

    // Each test uses a unique service key to avoid cross-test interference.
    private var serviceKey: String!

    override func setUp() {
        super.setUp()
        serviceKey = "com.meetingbar.test.\(UUID().uuidString)"
    }

    override func tearDown() {
        Keychain.delete(for: serviceKey)
        serviceKey = nil
        super.tearDown()
    }

    // MARK: - Save and load

    func test_saveAndLoad_roundTrip() {
        let data = "Hello Keychain".data(using: .utf8)!

        let saved = Keychain.save(data: data, for: serviceKey)
        XCTAssertTrue(saved)

        let loaded = Keychain.load(for: serviceKey)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(String(data: loaded!, encoding: .utf8), "Hello Keychain")
    }

    // MARK: - Load unknown key returns nil

    func test_load_unknownKey_returnsNil() {
        let result = Keychain.load(for: "com.meetingbar.test.doesnotexist.\(UUID().uuidString)")
        XCTAssertNil(result)
    }

    // MARK: - Delete

    func test_delete_afterSave_loadReturnsNil() {
        let data = "secret".data(using: .utf8)!
        Keychain.save(data: data, for: serviceKey)

        let deleted = Keychain.delete(for: serviceKey)
        XCTAssertTrue(deleted)

        let loaded = Keychain.load(for: serviceKey)
        XCTAssertNil(loaded, "After deletion, load should return nil")
    }

    // MARK: - Overwrite (save twice)

    func test_saveTwice_overwrites() {
        let first = "first".data(using: .utf8)!
        let second = "second".data(using: .utf8)!

        Keychain.save(data: first, for: serviceKey)
        Keychain.save(data: second, for: serviceKey)

        let loaded = Keychain.load(for: serviceKey)
        XCTAssertEqual(String(data: loaded!, encoding: .utf8), "second",
                       "Second save should overwrite first")
    }
}
