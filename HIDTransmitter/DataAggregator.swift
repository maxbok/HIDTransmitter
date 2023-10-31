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

    private let cpuUsageReport = CPUUsageReport()

    func start() {
        cpuUsageReport.setup()

        timer.fire()
    }

    private func transmit(_ timer: Timer) {
        cpuUsageReport.updateInfo()

        let components: [ReportComponent] = [
            DateReport(), 
            HostReport(),
            cpuUsageReport
        ]
        let report = Report(components: components)
        block?(report)
    }

}
