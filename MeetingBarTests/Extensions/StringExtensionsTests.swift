import Foundation
import XCTest

@testable import MeetingBar

class StringExtensionsTests: XCTestCase {
    // MARK: withLinksEnabled

    func testLinkDetectionPicksUpHttpDotComLinks() throws {
        let urlString = "http://example.com"
        let testString = NSAttributedString(string: "\(urlString)")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpDotComLinksSubstring() throws {
        let urlString = "http://example.com"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpDotComLinksSubstringNoSpacePrefix() throws {
        let urlString = "http://example.com"
        let testString = NSAttributedString(string: "prefix\(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpDotComLinksSubstringWithQueryParams() throws {
        let urlString = "http://example.com?exampleParam=true&anotherParam=12498"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpsDotComLinks() throws {
        let urlString = "https://example.com"
        let testString = NSAttributedString(string: "\(urlString)")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpsDotComLinksSubstring() throws {
        let urlString = "https://example.com"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpsDotComLinksSubstringNoSpacePrefix() throws {
        let urlString = "https://example.com"
        let testString = NSAttributedString(string: "prefix\(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpsDotComLinksSubstringWithQueryParams() throws {
        let urlString = "https://example.com?exampleParam=true&anotherParam=12498"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpHttpsDotIoLinksSubstringWithQueryParams() throws {
        let urlString = "https://example.io?exampleParam=true&anotherParam=12498"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpIPAddressLinksSubstring() throws {
        let urlString = "https://127.0.0.1"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }

    func testLinkDetectionPicksUpIPAddressLinksSubstringWithPort() throws {
        let urlString = "https://127.0.0.1:9001"
        let testString = NSAttributedString(string: "prefix \(urlString) suffix")
        let expectedRange = NSRange(location: 0, length: testString.string.utf16.count)
        let resultString = testString.withLinksEnabled()

        resultString.enumerateAttributes(in: expectedRange) { attrDict, range, _ in
            if let linkAttr = attrDict[.link] as? URL {
                XCTAssert(expectedRange.intersection(range)?.length ?? 0 > 0)
                XCTAssert(linkAttr.absoluteString == urlString)
            }
        }
    }
}

// MARK: - String extensions (non-link)

class StringExtensionMethodsTests: XCTestCase {

    // MARK: htmlTagsStripped

    func test_htmlTagsStripped_withTags_removesTagsAndKeepsContent() {
        let html = "<p>Hello <b>World</b></p>"
        let stripped = html.htmlTagsStripped()
        XCTAssertTrue(stripped.contains("Hello"))
        XCTAssertTrue(stripped.contains("World"))
        XCTAssertFalse(stripped.contains("<p>"))
        XCTAssertFalse(stripped.contains("<b>"))
    }

    func test_htmlTagsStripped_withNoTags_returnsOriginal() {
        let plain = "Just plain text"
        XCTAssertEqual(plain.htmlTagsStripped(), plain)
    }

    // MARK: replacingFirstOccurrence

    func test_replacingFirstOccurrence_replacesOnlyFirst() {
        let input = "foo bar foo baz foo"
        let result = input.replacingFirstOccurrence(of: "foo", with: "qux")
        XCTAssertEqual(result, "qux bar foo baz foo")
    }

    func test_replacingFirstOccurrence_withNoMatch_returnsOriginal() {
        let input = "hello world"
        let result = input.replacingFirstOccurrence(of: "xyz", with: "abc")
        XCTAssertEqual(result, "hello world")
    }

    // MARK: fileName

    func test_fileName_extractsNameWithoutExtension() {
        let path = "/Users/alice/Documents/report.pdf"
        XCTAssertEqual(path.fileName(), "report")
    }

    func test_fileName_withNoExtension_returnsName() {
        let path = "/tmp/Makefile"
        XCTAssertEqual(path.fileName(), "Makefile")
    }

    // MARK: decodeUrl

    func test_decodeUrl_decodesPercentEncoding() {
        let encoded = "Hello%20World"
        XCTAssertEqual(encoded.decodeUrl(), "Hello World")
    }

    func test_decodeUrl_withNoEncoding_returnsOriginal() {
        let plain = "HelloWorld"
        XCTAssertEqual(plain.decodeUrl(), "HelloWorld")
    }
}
