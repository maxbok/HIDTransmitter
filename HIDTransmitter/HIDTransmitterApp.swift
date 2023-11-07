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

    var disposables: Set<AnyCancellable> = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor.start()
    }

}
