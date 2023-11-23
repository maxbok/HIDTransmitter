//
//  MenuBarContent.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 14/11/2023.
//

import SwiftUI
import Combine

struct MenuBarContent: View {

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.status.display)

            if viewModel.presentReports {
                Divider()

                reports
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .frame(width: 200, alignment: .leading)
    }

    private var reports: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reports")
                .font(.subheadline)
                .foregroundStyle(.tertiary)

            if let date = viewModel.date {
                Text(date)
            }

            CPUUsageView(viewModel.cpuUsage)
        }
    }

    @StateObject private var viewModel: MenuBarContentModel

    init(deviceMonitor: DeviceMonitor) {
        _viewModel = StateObject(wrappedValue: MenuBarContentModel(deviceMonitor: deviceMonitor))
    }

}

class MenuBarContentModel: ObservableObject {

    enum Status {
        case noKeyboard
        case keyboardConnected

        var display: String {
            switch self {
            case .noKeyboard:           return "No keyboard connected"
            case .keyboardConnected:    return "Keyboard connected"
            }
        }
    }

    @Published private(set) var status: Status = .noKeyboard
    
    @Published private(set) var presentReports = false
    @Published private(set) var date: String?
    @Published private(set) var cpuUsage: [UInt8] = []

    private var disposables: Set<AnyCancellable> = []

    init(deviceMonitor: DeviceMonitor) {
        deviceMonitor.$device
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.status = $0 == nil ? .noKeyboard : .keyboardConnected
            }
            .store(in: &disposables)

        deviceMonitor.$lastReportComponent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] component in
                switch component?.type {
                case .date:
                    self?.date = component?.display
                case .cpuUsage:
                    self?.cpuUsage = component?.byteArray ?? []
                default:
                    break
                }
            }
            .store(in: &disposables)

        $date.combineLatest($cpuUsage)
            .receive(on: DispatchQueue.main)
            .map { $0.0 != nil || !$0.1.isEmpty }
            .sink { [weak self] in
                self?.presentReports = $0
            }
            .store(in: &disposables)
    }

}
