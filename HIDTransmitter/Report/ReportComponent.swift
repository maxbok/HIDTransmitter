//
//  ReportComponent.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

protocol ReportComponent {

    var componentType: ComponentType { get }

}

enum ComponentType: Int {
    case date
    case host
    case cpuUsage

    var maxLength: Int {
        30
    }
}
