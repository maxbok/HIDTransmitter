//
//  DataAggregator.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation
import Combine

class DataAggregator {

    var block: ((ReportComponent) -> Void)?

    private var dateTimer: Timer?
    private var cpuUsageTimer: Timer?

    private var lockedReport: LockedReport?
    private var hostReport: HostReport?
    private var dateReport: DateReport?
    private var cpuUsageReport: CPUUsageReport?

    private var disposables: Set<AnyCancellable> = []

    func start(with reportSize: Int) {
        setupReportComponents(with: reportSize)

        start()
    }

    func stop() {
        dateTimer?.invalidate()
        cpuUsageTimer?.invalidate()

        lockedReport.map { block?($0) }
    }

    private func start() {
        startTimers()

        hostReport.map { block?($0) }
    }

    private func setupReportComponents(with reportSize: Int) {
        lockedReport = LockedReport(reportSize: reportSize)
        hostReport = HostReport(reportSize: reportSize)
        dateReport = DateReport(reportSize: reportSize)
        cpuUsageReport = CPUUsageReport(reportSize: reportSize)
        cpuUsageReport?.setup()
    }

    private func startTimers() {
        guard let dateReport,
              let cpuUsageReport
        else { return }

        dateTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.block?(dateReport)
        }

        cpuUsageTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.block?(cpuUsageReport)
        }

        dateTimer?.fire()
        cpuUsageTimer?.fire()
    }

}
