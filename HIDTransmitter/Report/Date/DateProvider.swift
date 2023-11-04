//
//  DateProvider.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 02/11/2023.
//

import Foundation

protocol DateProviderConvertible {

    var now: Date? { get }

}

class DateProvider: DateProviderConvertible {

    var now: Date? {
        Date.now
    }

}
