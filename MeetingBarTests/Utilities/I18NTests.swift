//
//  I18NTests.swift
//  MeetingBarTests
//

import XCTest
@testable import MeetingBar

final class I18NTests: XCTestCase {

    override func tearDown() {
        // Reset to system language after each test
        I18N.instance.changeLanguage(to: .system)
        super.tearDown()
    }

    // MARK: - Singleton

    func test_instance_isSingleton() {
        let a = I18N.instance
        let b = I18N.instance
        XCTAssertTrue(a === b)
    }

    // MARK: - changeLanguage

    func test_changeLanguage_toEnglish_setsEnglishLocale() {
        let changed = I18N.instance.changeLanguage(to: .english)
        XCTAssertTrue(changed)
        XCTAssertEqual(I18N.instance.locale.identifier, "en")
    }

    func test_changeLanguage_toSystem_returnsTrue() {
        let changed = I18N.instance.changeLanguage(to: .system)
        XCTAssertTrue(changed)
    }

    // MARK: - localizedString

    func test_localizedString_afterEnglish_returnsNonEmptyString() {
        I18N.instance.changeLanguage(to: .english)
        let result = I18N.instance.localizedString(for: "general_ok")
        XCTAssertFalse(result.isEmpty)
    }

    func test_localizedString_knownKey_afterEnglish_returnsEnglishText() {
        I18N.instance.changeLanguage(to: .english)
        let result = I18N.instance.localizedString(for: "general_ok")
        // The English string for "general_ok" should be "OK" or similar
        XCTAssertFalse(result == "general_ok",
                       "A known key should not return the raw key when English bundle is loaded")
    }

    func test_loco_extensionMethod_returnsNonEmptyString() {
        I18N.instance.changeLanguage(to: .english)
        let result = "general_ok".loco()
        XCTAssertFalse(result.isEmpty)
    }
}
