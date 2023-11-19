//
//  HIDTransmitterApp.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 25/10/2023.
//

import SwiftUI
import Combine
import ServiceManagement

@main
struct HIDTransmitterApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            MenuBarContent(deviceMonitor: appDelegate.monitor)
        } label: {
            MenuBarLabel(deviceMonitor: appDelegate.monitor)
        }
        .menuBarExtraStyle(.window)
    }

}

class AppDelegate: NSObject, NSApplicationDelegate {

    let monitor = DeviceMonitor()

    var disposables: Set<AnyCancellable> = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor.start()

        try? SMAppService.mainApp.register()
    }

}
