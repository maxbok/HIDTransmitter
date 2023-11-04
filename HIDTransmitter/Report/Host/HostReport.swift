//
//  HostReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

class HostReport: ReportComponent {

    let maxSize: Int
    let type: ComponentType = .host

    var display: String {
        name ?? ""
    }

    var byteArray: [UInt8] {
        guard let name else { return [] }

        let array: [UInt8] = Array(name.utf8)

        guard array.count < maxByteArraySize else {
            return Array(array[0..<maxByteArraySize])
        }
        return array
    }

    private var name: String? {
        host.localizedName
    }

    private let host: HostConvertible

    init(reportSize: Int, host: HostConvertible = Host.current()) {
        maxSize = reportSize
        self.host = host
    }

}
