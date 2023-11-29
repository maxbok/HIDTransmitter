//
//  DeviceMonitor.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import AppKit
import Foundation
import Combine
import USBDeviceSwift

class DeviceMonitor {

    @Published private(set) var device: HIDDevice?

    @Published private(set) var isLocked = false

    @Published private(set) var lastReportComponent: ReportComponent?

    private let aggregator = DataAggregator()

    private let rfDeviceMonitor: HIDDeviceMonitor
    private let rfDeviceDaemon: Thread

    private var disposables: Set<AnyCancellable> = []

    init() {
        rfDeviceMonitor = HIDDeviceMonitor(
            [
                HIDMonitorData(vendorId: 0x4653, productId: 0x0001, usagePage: 0xFF60, usage: 0x61)
            ],
            reportSize: 32
        )

        rfDeviceDaemon = Thread(
            target: self.rfDeviceMonitor,
            selector: #selector(self.rfDeviceMonitor.start),
            object: nil
        )
    }

    func start() {
        aggregator.block = write(reportComponent:)

        setupBindings()

        rfDeviceDaemon.start()
    }

    private func write(reportComponent: ReportComponent) {
        guard let device else { return }

        reportComponent.updateData()
        device.write(report: reportComponent)
        lastReportComponent = reportComponent
    }

    // MARK: - Bindings

    private func setupBindings() {
        $device.combineLatest($isLocked)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device, isLocked in
                if let device,
                   !isLocked {
                    self?.aggregator.start(with: device.reportSize)
                } else {
                    self?.aggregator.stop()
                }
            }
            .store(in: &disposables)

        NotificationCenter.default.publisher(for: .HIDDeviceConnected)
            .sink { [weak self] notification in
                guard let self,
                      let hidDevice = notification.device,
                      self.device == nil
                else { return }

                self.device = hidDevice
            }
            .store(in: &disposables)

        NotificationCenter.default.publisher(for: .HIDDeviceDisconnected)
            .sink { [weak self] notification in
                guard let self,
                      let object = notification.object as? [String: Any],
                      let id = object["id"] as? Int32,
                      self.device?.id == id
                else { return }

                device = nil
            }
            .store(in: &disposables)

        screensDidSleep
            .sink { [weak self] _ in
                self?.isLocked = true
            }
            .store(in: &disposables)

        screensDidWake
            .sink { [weak self] _ in
                self?.isLocked = false
            }
            .store(in: &disposables)
    }

}

// MARK: - Notifications

private extension DeviceMonitor {

    var screensDidSleep: NotificationCenter.Publisher {
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.screensDidSleepNotification)
    }

    var screensDidWake: NotificationCenter.Publisher {
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.screensDidWakeNotification)
    }

}

private extension Notification {

    var device: HIDDevice? {
        guard let content = object as? [String: Any] else {
            return nil
        }

        return content["device"] as? HIDDevice
    }

}
