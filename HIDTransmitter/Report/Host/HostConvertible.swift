//
//  HostConvertible.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 02/11/2023.
//

import Foundation

protocol HostConvertible {
    var localizedName: String? { get }
}

extension Host: HostConvertible {}
