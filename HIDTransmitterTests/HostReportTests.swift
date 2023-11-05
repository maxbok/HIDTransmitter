//
//  HostReportTests.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 31/10/2023.
//

import XCTest
@testable import HIDTransmitter

final class HostReportTests: XCTestCase {

    var hostMock: HostMock!
    var report: HostReport!

    override func setUp() {
        hostMock = HostMock(localizedName: "host name")
        report = HostReport(reportSize: 12, host: hostMock)
    }

    func testByteArray() {
        XCTAssertEqual(String(bytes: report.byteArray, encoding: .utf8),
                       "host name")

        hostMock.localizedName = "test super super long long looooong"
        XCTAssertEqual(String(bytes: report.byteArray, encoding: .utf8),
                       "test supe")
    }

    func testDisplay() {
        hostMock.localizedName = "test"
        XCTAssertEqual(report.display, "test")

        hostMock.localizedName = "test super super long long looooong"
        XCTAssertEqual(report.display, "test super super long long looooong")
    }

}
