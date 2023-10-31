//
//  Report.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

struct Report {

    private var components: [ReportComponent]

    init(components: [ReportComponent]) {
        self.components = components
    }

    var data: Data? {
        nil
    }

}
