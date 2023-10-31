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
        report = HostReport(host: hostMock)
    }

    func testByteArray() {
        let byteArray = report.byteArray

        XCTAssertEqual(byteArray.count, 9)
        XCTAssertEqual(String(UnicodeScalar(byteArray[0])), "h")
        XCTAssertEqual(String(UnicodeScalar(byteArray[1])), "o")
        XCTAssertEqual(String(UnicodeScalar(byteArray[2])), "s")
        XCTAssertEqual(String(UnicodeScalar(byteArray[3])), "t")
        XCTAssertEqual(String(UnicodeScalar(byteArray[4])), " ")
        XCTAssertEqual(String(UnicodeScalar(byteArray[5])), "n")
        XCTAssertEqual(String(UnicodeScalar(byteArray[6])), "a")
        XCTAssertEqual(String(UnicodeScalar(byteArray[7])), "m")
        XCTAssertEqual(String(UnicodeScalar(byteArray[8])), "e")
    }

    func testDisplay() {
        hostMock.localizedName = "test"
        XCTAssertEqual(report.display, "test")

        hostMock.localizedName = "test super super long long looooong"
        XCTAssertEqual(report.display, "test super super long long loo")
    }

}
