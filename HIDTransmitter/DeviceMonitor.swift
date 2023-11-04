//
//  DeviceMonitor.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation
import Combine
import USBDeviceSwift

class DeviceMonitor {

    @Published private(set) var device: HIDDevice?

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
        setupBindings()

        rfDeviceDaemon.start()
    }

    func write(reportComponent: ReportComponent) {
        guard let device else { return }

        reportComponent.updateData()
        device.write(report: reportComponent)
    }

    // MARK: -

    func setupBindings() {
        NotificationCenter.default.publisher(for: .HIDDeviceConnected)
            .sink { [weak self] notification in
                guard let self,
                      let hidDevice = notification.device,
                      self.device == nil
                else { return }
                
                self.device = hidDevice

                print("Device connected: \(hidDevice)")
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

                print("Device disconnected: \(id)")
            }
            .store(in: &disposables)
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
