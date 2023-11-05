//
//  ReportComponentTests.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 04/11/2023.
//

import XCTest
@testable import HIDTransmitter

final class ReportComponentTests: XCTestCase {

    var report: ReportMock!

    override func setUp() {
        report = ReportMock()
    }

    func testCompomentTypeData() {
        report.type = .host
        XCTAssertEqual(report.toByteArray(), [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

        report.type = .date
        XCTAssertEqual(report.toByteArray(), [1, 0, 0, 0, 0, 0, 0, 0, 0, 0])

        report.type = .cpuUsage
        XCTAssertEqual(report.toByteArray(), [2, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    }

    func testData() {
        report.byteArray = []
        XCTAssertEqual(report.toByteArray(), [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

        report.byteArray = [48]
        XCTAssertEqual(report.toByteArray(), [0, 1, 48, 0, 0, 0, 0, 0, 0, 0])

        report.byteArray = [10, 8, 9, 6, 7, 4, 5, 3, 2, 1]
        XCTAssertEqual(report.toByteArray(), [0, 10, 10, 8, 9, 6, 7, 4, 5, 0])
    }

}

class ReportMock: ReportComponent {
    
    let maxSize = 10
    var type: HIDTransmitter.ComponentType = .host
    let display = ""
    var byteArray: [UInt8] = []

}

private extension ReportComponent {

    func toByteArray() -> [UInt8] {
        let buffer = UnsafeBufferPointer(start: data!.pointer, count: data!.count)
        return Array(buffer)
    }

}
