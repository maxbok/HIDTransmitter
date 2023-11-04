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
    var data: (data: UnsafePointer<UInt8>, count: Int) { get }

    func updateData()

}

extension ReportComponent {

    var maxByteArraySize: Int {
        maxSize - (headerSize + tail.count)
    }

    var data: (data: UnsafePointer<UInt8>, count: Int) {
        let report = header + byteArray + tail

        let correctData = Data(bytes: UnsafePointer<UInt8>(report), count: maxSize)

        let pointer = (correctData as NSData).bytes.bindMemory(to: UInt8.self, capacity: correctData.count)

        return (pointer, correctData.count)
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
    case host
    case date
    case cpuUsage
}
