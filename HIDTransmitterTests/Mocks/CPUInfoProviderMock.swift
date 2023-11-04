//
//  CPUInfoProviderMock.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 04/11/2023.
//

import Foundation
@testable import HIDTransmitter

class CPUInfoProviderMock: CPUInfoProviderConvertible {

    var coreUsagesMock: [CPUInfoProvider.CoreUsage] = []

    func setup() {}

    func coreUsages() -> [CPUInfoProvider.CoreUsage] {
        coreUsagesMock
    }

}
