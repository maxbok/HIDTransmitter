//
//  DataAggregator.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation

class DataAggregator {

    var block: ((ReportComponent) -> Void)?

    private var dateTimer: Timer?
    private var cpuUsageTimer: Timer?

    private var hostReport: HostReport?
    private var dateReport: DateReport?
    private var cpuUsageReport: CPUUsageReport?

    func start(with reportSize: Int) {
        setupReportComponents(with: reportSize)

        startTimers()
        hostReport.map { block?($0) }
    }

    func stop() {
        dateTimer?.invalidate()
        cpuUsageTimer?.invalidate()
    }

    private func setupReportComponents(with reportSize: Int) {
        hostReport = HostReport(reportSize: reportSize)
        dateReport = DateReport(reportSize: reportSize)
        cpuUsageReport = CPUUsageReport(reportSize: reportSize)
        cpuUsageReport?.setup()
    }

    private func startTimers() {
        guard let dateReport,
              let cpuUsageReport
        else { return }

        dateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.block?(dateReport)
        }

        cpuUsageTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.block?(cpuUsageReport)
        }

        dateTimer?.fire()
        cpuUsageTimer?.fire()
    }

}
