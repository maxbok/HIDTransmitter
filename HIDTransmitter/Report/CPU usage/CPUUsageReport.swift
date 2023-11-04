//
//  CPUUsageReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

class CPUUsageReport: ReportComponent {

    let maxSize: Int

    var componentType: ComponentType {
        .cpuUsage
    }

    var display: String {
        byteArray
            .map(String.init)
            .joined(separator: " ")
    }

    var byteArray: [UInt8] {
        coreUsages
            .map(\.percentValue)
    }

    private let infoProvider: CPUInfoProviderConvertible
    private var coreUsages: [CPUInfoProvider.CoreUsage] = []

    init(reportSize: Int, infoProvider: CPUInfoProviderConvertible = CPUInfoProvider()) {
        maxSize = reportSize
        self.infoProvider = infoProvider
    }

    func setup() {
        infoProvider.setup()
    }

    func updateData() {
        coreUsages = infoProvider.coreUsages()
    }

}
