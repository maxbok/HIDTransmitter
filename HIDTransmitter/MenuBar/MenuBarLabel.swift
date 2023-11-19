//
//  MenuBarLabel.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 14/11/2023.
//

import SwiftUI
import Combine

struct MenuBarLabel: View {
    
    var body: some View {
        Image(systemName: viewModel.imageName)
    }

    @StateObject private var viewModel: MenuBarLabelModel

    init(deviceMonitor: DeviceMonitor) {
        _viewModel = StateObject(wrappedValue: MenuBarLabelModel(deviceMonitor: deviceMonitor))
    }

}

private class MenuBarLabelModel: ObservableObject {

    @Published var imageName = "questionmark"

    private var cancellable: AnyCancellable?

    init(deviceMonitor: DeviceMonitor) {
        cancellable = deviceMonitor.$device
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.imageName = $0 == nil ? "keyboard" : "keyboard.fill"
            }
    }

}
