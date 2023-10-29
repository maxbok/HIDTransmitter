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

    private var devices: [HIDDevice] = []

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

    func write(report: Report) {
        guard let data = report.data else { return }

        devices.forEach {
            $0.write(data: data)
        }
    }

    // MARK: -

    func setupBindings() {
        NotificationCenter.default.publisher(for: .HIDDeviceConnected)
            .sink { [weak self] notification in
                guard let hidDevice = notification.device,
                      self?.devices.contains(where: { $0.id == hidDevice.id }) == false
                else { return }
                
                self?.devices.append(hidDevice)

                print("Device connected: \(hidDevice)")
            }
            .store(in: &disposables)

        NotificationCenter.default.publisher(for: .HIDDeviceDisconnected)
            .sink { [weak self] notification in
                guard let object = notification.object as? [String: Any],
                      let id = object["id"] as? Int32
                else { return }

                self?.devices.removeAll(where: { $0.id == id })

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
