//
//  CPUUsageReportTests.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 04/11/2023.
//

import XCTest
@testable import HIDTransmitter

final class CPUUsageReportTests: XCTestCase {

    var infoProvider: CPUInfoProviderMock!
    var report: CPUUsageReport!

    override func setUp() {
        infoProvider = CPUInfoProviderMock()
        infoProvider.coreUsagesMock = [
            CPUInfoProvider.CoreUsage(inUse: 4, total: 100),
            CPUInfoProvider.CoreUsage(inUse: 10, total: 100),
            CPUInfoProvider.CoreUsage(inUse: 84, total: 100)
        ]
        report = CPUUsageReport(reportSize: 32, infoProvider: infoProvider)
        report.updateData()
    }

    func testDisplay() {
        XCTAssertEqual(report.display, "4 10 84")
    }

    func testByteArray() {
        XCTAssertEqual(report.byteArray, [4, 10, 84])
    }

}
