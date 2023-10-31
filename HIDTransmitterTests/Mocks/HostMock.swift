//
//  HostMock.swift
//  HIDTransmitterTests
//
//  Created by Maxime Bokobza on 31/10/2023.
//

import Foundation
@testable import HIDTransmitter

class HostMock: HostConvertible {

    var localizedName: String?

    init(localizedName: String? = nil) {
        self.localizedName = localizedName
    }

}
