//
//  DataAggregator.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 28/10/2023.
//

import Foundation

class DataAggregator {

    var block: ((Report) -> Void)?

    private lazy var timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: transmit)

    func start() {
        timer.fire()
    }

    private func transmit(_ timer: Timer) {
        let report = Report()
        block?(report)
    }

}
