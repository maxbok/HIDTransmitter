//
//  HIDDevice+Utils.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation
import USBDeviceSwift

extension HIDDevice {

    func write(report: ReportComponent) {
        guard let formatterData = report.data else { return }

        IOHIDDeviceSetReport(
            device,
            kIOHIDReportTypeOutput,
            CFIndex(report.type.rawValue),
            formatterData.pointer,
            formatterData.count
        )

        print(report.display)
    }

}
