//
//  HostReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

struct HostReport: ReportComponent {

    var componentType: ComponentType {
        .host
    }

    var display: String {
        name ?? ""
    }

    var byteArray: [UInt8] {
        guard let name else { return [] }

        return [UInt8](name.utf8)
    }

    private var name: String? {
        guard let name = host.localizedName else { return nil }

        return String(name.prefix(componentType.maxLength))
    }

    private let host: HostConvertible

    init(host: HostConvertible = Host.current()) {
        self.host = host
    }

}

protocol HostConvertible {
    var localizedName: String? { get }
}

extension Host: HostConvertible {}
