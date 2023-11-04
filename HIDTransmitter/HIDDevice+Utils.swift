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
        let formatterData = report.data

        IOHIDDeviceSetReport(
            device,
            kIOHIDReportTypeOutput,
            CFIndex(report.type.rawValue),
            formatterData.data,
            formatterData.count
        )

        print(report.display)
    }

}
