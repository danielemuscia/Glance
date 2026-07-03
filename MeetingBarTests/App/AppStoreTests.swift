//
//  AppStoreTests.swift
//  MeetingBarTests
//

import XCTest
@testable import MeetingBar

// Note: completeStoreTransactions(), checkAppSource(), restorePatronagePurchases(),
// purchasePatronage() all depend on the SwiftyStoreKit singleton, which requires
// StoreKit entitlements and cannot be tested in unit tests.
// Only getPatronageDurationFromProductID() is a pure function and is tested here.

final class AppStoreTests: XCTestCase {

    func test_getPatronageDuration_threeMonth_returns3() {
        XCTAssertEqual(getPatronageDurationFromProductID(PatronageProducts.threeMonth), 3)
    }

    func test_getPatronageDuration_sixMonth_returns6() {
        XCTAssertEqual(getPatronageDurationFromProductID(PatronageProducts.sixMonth), 6)
    }

    func test_getPatronageDuration_twelveMonth_returns12() {
        XCTAssertEqual(getPatronageDurationFromProductID(PatronageProducts.twelveMonth), 12)
    }

    func test_getPatronageDuration_unknownProductID_returns0() {
        XCTAssertEqual(getPatronageDurationFromProductID("com.example.unknown"), 0)
    }

    func test_getPatronageDuration_emptyString_returns0() {
        XCTAssertEqual(getPatronageDurationFromProductID(""), 0)
    }
}
