//
//  LockedReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 07/11/2023.
//

import Foundation

class LockedReport: ReportComponent {

    let maxSize: Int
    let type: ComponentType = .locked

    var display: String {
        "is locked"
    }

    var byteArray: [UInt8] {
        []
    }

    init(reportSize: Int) {
        maxSize = reportSize
    }

}
