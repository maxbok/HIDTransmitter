//
//  Report.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

struct Report {
    
    var data: Data? {
        Date().description.data(using: .utf8)
    }

}
