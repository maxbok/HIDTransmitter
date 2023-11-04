//
//  HIDDevice+Utils.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation
import USBDeviceSwift

extension HIDDevice {

    func write(data: Data) {
        let reportId:UInt8 = 2
        guard let formatterData = formattedData(data, reportId: reportId) else {
            return
        }

        IOHIDDeviceSetReport(
            device,
            kIOHIDReportTypeOutput,
            CFIndex(reportId),
            formatterData.data,
            formatterData.count
        )

        print("Did write \(String(data: data, encoding: .utf8))")
    }

    private func formattedData(_ data: Data, reportId: UInt8) -> (data: UnsafePointer<UInt8>, count: Int)? {
        var bytesArray: [UInt8] = Array(data)
        bytesArray.insert(reportId, at: 0)
        bytesArray.append(0)// hack every report should end with 0 byte

        if (bytesArray.count > reportSize) {
            print("Output data too large for USB report")
            return nil
        }

        let correctData = Data(bytes: UnsafePointer<UInt8>(bytesArray), count: reportSize)

        let truc = (correctData as NSData).bytes.bindMemory(to: UInt8.self, capacity: correctData.count)

        return (truc, correctData.count)
    }

}
