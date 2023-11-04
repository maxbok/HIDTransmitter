//
//  ReportComponent.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

protocol ReportComponent {

    var maxSize: Int { get }
    var componentType: ComponentType { get }
    var display: String { get }
    var byteArray: [UInt8] { get }

    func updateData()

}

extension ReportComponent {

    var maxByteArraySize: Int {
        maxSize - componentType.headerSize
    }

    func updateData() {}

}

enum ComponentType: Int {
    case date
    case host
    case cpuUsage

    var headerSize: Int {
        2
    }
}
