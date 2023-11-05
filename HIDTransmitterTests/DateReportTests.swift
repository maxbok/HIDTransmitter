//
//  DateReportTests.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 01/11/2023.
//

import XCTest
@testable import HIDTransmitter

final class DateReportTests: XCTestCase {

    var report: DateReport!
    var dateProviderMock: DateProviderMock!

    override func setUp() {
        dateProviderMock = DateProviderMock()
        report = DateReport(reportSize: 32, dateProviderMock)

        let calendar = Calendar.current
        let components = DateComponents(timeZone: nil, year: 2007, month: 6, day: 5, hour: 12, minute: 34)

        dateProviderMock.now = calendar.date(from: components)
        report.updateData()
    }

    func testDisplay() {
        XCTAssertEqual(report.display, "12h34 05/06/2007")
    }

    func testByteArray() {
        XCTAssertEqual(report.byteArray, [12, 34, 5, 6, 215, 7]) // 7 * 256 + 215 = 2007
    }

}
