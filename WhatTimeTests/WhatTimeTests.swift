import XCTest
@testable import WhatTime

// MARK: - Parser Tests

final class NaturalLanguageParserTests: XCTestCase {

    func testDisplayPattern_8pmPalauTime() {
        let result = NaturalLanguageParser.parse("8pm palau time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.minute, 0)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Palau")
        XCTAssertNil(result?.destinationZone)
    }

    func testConversionPattern_8pmPalauToGuam() {
        let result = NaturalLanguageParser.parse("8pm palau time to guam time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.minute, 0)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Palau")
        XCTAssertEqual(result?.destinationZone?.identifier, "Pacific/Guam")
    }

    func testDisplayPattern_9amGuam() {
        let result = NaturalLanguageParser.parse("9am guam time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 9)
        XCTAssertEqual(result?.minute, 0)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Guam")
    }

    func testDisplayPattern_withMinutes() {
        let result = NaturalLanguageParser.parse("8:30pm manila time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.minute, 30)
        XCTAssertEqual(result?.sourceZone.identifier, "Asia/Manila")
    }

    func testNaturalLanguagePreamble() {
        let result = NaturalLanguageParser.parse("what is 8pm palau time to guam time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.destinationZone?.identifier, "Pacific/Guam")
    }

    func testCaseInsensitive() {
        let result = NaturalLanguageParser.parse("8PM PALAU TIME")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
    }

    func testMidnight_12am() {
        let result = NaturalLanguageParser.parse("12am guam time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 0)
    }

    func testNoon_12pm() {
        let result = NaturalLanguageParser.parse("12pm guam time")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 12)
    }

    func testUnknownTimezone_returnsNil() {
        XCTAssertNil(NaturalLanguageParser.parse("8pm unknowncity time"))
    }

    func testInvalidInput_returnsNil() {
        XCTAssertNil(NaturalLanguageParser.parse("hello world"))
        XCTAssertNil(NaturalLanguageParser.parse("what time is it"))
        XCTAssertNil(NaturalLanguageParser.parse(""))
    }

    // MARK: Loose patterns

    func testLooseDisplay_hourAndZone() {
        let result = NaturalLanguageParser.parse("10 guam")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 10)
        XCTAssertEqual(result?.minute, 0)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Guam")
        XCTAssertNil(result?.destinationZone)
    }

    func testLooseDisplay_shortCode() {
        let result = NaturalLanguageParser.parse("11 ph")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 11)
        XCTAssertEqual(result?.sourceZone.identifier, "Asia/Manila")
    }

    func testLooseDisplay_withAmPm() {
        let result = NaturalLanguageParser.parse("8pm guam")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Guam")
    }

    func testLooseDisplay_withMinutes() {
        let result = NaturalLanguageParser.parse("10:30 manila")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 10)
        XCTAssertEqual(result?.minute, 30)
        XCTAssertEqual(result?.sourceZone.identifier, "Asia/Manila")
    }

    func testLooseConversion_noTimeSuffix() {
        let result = NaturalLanguageParser.parse("10 guam to manila")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 10)
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Guam")
        XCTAssertEqual(result?.destinationZone?.identifier, "Asia/Manila")
    }

    func testLooseConversion_shortCodes() {
        let result = NaturalLanguageParser.parse("9 ph to guam")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 9)
        XCTAssertEqual(result?.sourceZone.identifier, "Asia/Manila")
        XCTAssertEqual(result?.destinationZone?.identifier, "Pacific/Guam")
    }

    func testLooseDisplay_unknownZone_returnsNil() {
        XCTAssertNil(NaturalLanguageParser.parse("10 nowhere"))
    }

    // MARK: Current-timezone patterns

    func testZoneOnly_singleWord() {
        let result = NaturalLanguageParser.parse("canada")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.sourceZone.identifier, "America/Toronto")
        XCTAssertNil(result?.destinationZone)
        if let hour = result?.hour, let minute = result?.minute {
            XCTAssertTrue((0...23).contains(hour))
            XCTAssertTrue((0...59).contains(minute))
        }
    }

    func testZoneOnly_caseInsensitive() {
        let lower = NaturalLanguageParser.parse("australia")
        let upper = NaturalLanguageParser.parse("Australia")
        XCTAssertNotNil(lower)
        XCTAssertEqual(lower?.sourceZone.identifier, upper?.sourceZone.identifier)
    }

    func testZoneOnly_twoWords() {
        let result = NaturalLanguageParser.parse("hong kong")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.sourceZone.identifier, "Asia/Hong_Kong")
    }

    func testZoneOnly_unknown_returnsNil() {
        XCTAssertNil(NaturalLanguageParser.parse("narnia"))
    }

    func testNow_returnsCurrentTime() {
        let before = Calendar.current.dateComponents(in: .current, from: Date())
        let result = NaturalLanguageParser.parse("now")
        let after = Calendar.current.dateComponents(in: .current, from: Date())
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
        XCTAssertNil(result?.destinationZone)
        if let hour = result?.hour, let minute = result?.minute {
            XCTAssertTrue((0...23).contains(hour))
            XCTAssertTrue((0...59).contains(minute))
            // Parsed time should fall within the window of the test run
            let validHours = Set([before.hour, after.hour].compactMap { $0 })
            XCTAssertTrue(validHours.contains(hour))
        }
    }

    func testCurrentZone_bareHour() {
        let result = NaturalLanguageParser.parse("10")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 10)
        XCTAssertEqual(result?.minute, 0)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
        XCTAssertNil(result?.destinationZone)
    }

    func testCurrentZone_withAm() {
        let result = NaturalLanguageParser.parse("10am")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 10)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
    }

    func testCurrentZone_withPm() {
        let result = NaturalLanguageParser.parse("11pm")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 23)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
    }

    func testCurrentZone_compactFourDigit() {
        let result = NaturalLanguageParser.parse("1130")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 11)
        XCTAssertEqual(result?.minute, 30)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
    }

    func testCurrentZone_compactThreeDigit() {
        let result = NaturalLanguageParser.parse("930")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 9)
        XCTAssertEqual(result?.minute, 30)
        XCTAssertEqual(result?.sourceZone.identifier, TimeZone.current.identifier)
    }

    func testCurrentZone_compactWithPm() {
        let result = NaturalLanguageParser.parse("1130pm")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 23)
        XCTAssertEqual(result?.minute, 30)
    }

    func testCurrentZone_singleLetterA() {
        let result = NaturalLanguageParser.parse("1230a")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 0)  // 12am = midnight
        XCTAssertEqual(result?.minute, 30)
    }

    func testCurrentZone_singleLetterP() {
        let result = NaturalLanguageParser.parse("1230p")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 12)
        XCTAssertEqual(result?.minute, 30)
    }

    func testCurrentZone_singleLetterP_nonNoon() {
        let result = NaturalLanguageParser.parse("830p")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.hour, 20)
        XCTAssertEqual(result?.minute, 30)
    }

    func testCurrentZone_doesNotMatchWithTrailingZone() {
        // "10 guam" should still resolve to Guam, not current zone
        let result = NaturalLanguageParser.parse("10 guam")
        XCTAssertEqual(result?.sourceZone.identifier, "Pacific/Guam")
    }
}

// MARK: - Conversion Service Tests

final class TimeConversionServiceTests: XCTestCase {

    func testConvertToAllPresets() throws {
        let query = try XCTUnwrap(NaturalLanguageParser.parse("8pm palau time"))
        let results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
        XCTAssertEqual(results.count, TimeZoneData.presets.count)
    }

    func testConvertToSingleDestination() throws {
        let query = try XCTUnwrap(NaturalLanguageParser.parse("8pm palau time to guam time"))
        let results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.entry.id, "Pacific/Guam")
    }

    func testSourceIsMarked() throws {
        let query = try XCTUnwrap(NaturalLanguageParser.parse("8pm palau time"))
        let results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
        let palauResult = results.first { $0.entry.id == "Pacific/Palau" }
        XCTAssertNotNil(palauResult)
        XCTAssertTrue(palauResult?.isSource ?? false)
    }

    func testDestinationIsMarked() throws {
        let query = try XCTUnwrap(NaturalLanguageParser.parse("8pm palau time to guam time"))
        let results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
        XCTAssertTrue(results.first?.isDestination ?? false)
    }

    func testFormattedTimeNotEmpty() throws {
        let query = try XCTUnwrap(NaturalLanguageParser.parse("9am manila time"))
        let results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
        for result in results {
            XCTAssertFalse(result.formattedTime.isEmpty, "\(result.entry.name) has empty time")
        }
    }
}
