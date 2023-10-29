//
//  HIDTransmitterApp.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 25/10/2023.
//

import SwiftUI

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

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor.start()

        aggregator.block = monitor.write(report:)
        aggregator.start()
    }

}
