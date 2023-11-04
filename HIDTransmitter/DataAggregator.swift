//
//  DataAggregator.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation

class DataAggregator {

    var block: ((Report) -> Void)?

    private lazy var timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: transmit)

    private let cpuUsageReport = CPUUsageReport(reportSize: 32)

    private lazy var components: [ReportComponent] = [
        DateReport(reportSize: 32),
        HostReport(reportSize: 32),
        cpuUsageReport
    ]

    func start() {
        cpuUsageReport.setup()

        timer.fire()
    }

    private func transmit(_ timer: Timer) {
        let report = Report(components: components)
        block?(report)
    }

}
