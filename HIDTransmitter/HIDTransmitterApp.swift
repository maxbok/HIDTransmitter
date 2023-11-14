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
        MenuBarExtra {
            MenuBarContent()
        } label: {
            MenuBarLabel(deviceMonitor: appDelegate.monitor)
        }

    }

}

class AppDelegate: NSObject, NSApplicationDelegate {

    let monitor = DeviceMonitor()

    var disposables: Set<AnyCancellable> = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor.start()
    }

}
