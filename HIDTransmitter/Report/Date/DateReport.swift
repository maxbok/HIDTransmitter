//
//  DateReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

class DateReport: ReportComponent {
    
    let maxSize: Int

    var componentType: ComponentType {
        .date
    }

    var display: String {
        guard let date else { return "" }

        return DateFormatter.displayFormatter.string(from: date)
    }

    var byteArray: [UInt8] {
        guard let date else { return [] }

        let dateString = DateFormatter.byteArrayFormatter.string(from: date)
        return Array(dateString.utf8)
    }

    private var date: Date?
    private var dateProvider: DateProviderConvertible

    init(reportSize: Int, _ dateProvider: DateProviderConvertible = DateProvider()) {
        maxSize = reportSize
        self.dateProvider = dateProvider
    }

    func updateData() {
        date = dateProvider.now
    }

}

extension DateFormatter {

    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH'h'mm dd/MM/yyyy"
        return formatter
    }()

    static let byteArrayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmddMMyyyy"
        return formatter
    }()

}
