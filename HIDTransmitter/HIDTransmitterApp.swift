//
//  HIDTransmitterApp.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 25/10/2023.
//

import SwiftUI
import Combine

@main
struct HIDTransmitterApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}

class AppDelegate: NSObject, NSApplicationDelegate {

    let monitor = DeviceMonitor()
    let aggregator = DataAggregator()

    var disposables: Set<AnyCancellable> = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard NSClassFromString("XCTestCase") == nil  else { return }

        monitor.start()

        aggregator.block = monitor.write(reportComponent:)

        monitor.$device
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                if let device {
                    self?.aggregator.start(with: device.reportSize)
                } else {
                    self?.aggregator.stop()
                }
            }
            .store(in: &disposables)
    }

}
