//
//  ReportComponent.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

protocol ReportComponent {

    var maxSize: Int { get }
    var type: ComponentType { get }
    var display: String { get }
    var byteArray: [UInt8] { get }
    var data: (pointer: UnsafePointer<UInt8>, count: Int)? { get }

    func updateData()

}

extension ReportComponent {

    var maxByteArraySize: Int {
        maxSize - (headerSize + tail.count)
    }

    var data: (pointer: UnsafePointer<UInt8>, count: Int)? {
        let content = byteArray.isEmpty ? [] : Array(byteArray.prefix(maxByteArraySize))
        var report = header + content + tail

        let delta = max(maxSize - report.count, 0)

        let emptyTail = Array(repeating: UInt8(0), count: delta)

        report += emptyTail

        let pointer = (Data(report) as NSData).bytes.bindMemory(to: UInt8.self, capacity: report.count)

        var byteReport: [UInt8] = []
        for i in 0..<report.count {
            byteReport.append(pointer[i])
        }
        print(byteReport)

        return (pointer, report.count)
    }

    private var headerSize: Int {
        2
    }

    private var header: [UInt8] {
        var header: [UInt8] = []
        header.append(type.rawValue)

        let count = min(byteArray.count, Int(UInt8.max))
        header.append(UInt8(count))

        return header
    }

    private var tail: [UInt8] {
        [0]
    }

    func updateData() {}

}

enum ComponentType: UInt8 {
    case locked
    case host
    case date
    case cpuUsage
}
