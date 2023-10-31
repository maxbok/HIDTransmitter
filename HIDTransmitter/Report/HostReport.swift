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

    var name: String? {
        Host.current().localizedName
    }

}
