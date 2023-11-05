//
//  DateReport.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 29/10/2023.
//

import Foundation

class DateReport: ReportComponent {
    
    let maxSize: Int
    let type: ComponentType = .date

    var display: String {
        guard let date else { return "" }

        return DateFormatter.displayFormatter.string(from: date)
    }

    var byteArray: [UInt8] {
        guard let date else { return [] }

        let calendar = Calendar.current

        let hour = UInt8(calendar.component(.hour, from: date))
        let minute = UInt8(calendar.component(.minute, from: date))
        let day = UInt8(calendar.component(.day, from: date))
        let month = UInt8(calendar.component(.month, from: date))
        let year = UInt16(calendar.component(.year, from: date))

        return [hour, minute, day, month] + year.toByteArray()
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

private extension DateFormatter {

    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH'h'mm dd/MM/yyyy"
        return formatter
    }()

}

private extension UInt16 {

    func toByteArray() -> [UInt8] {
        let count = MemoryLayout<Self>.size

        let bytesPointer = withUnsafePointer(to: self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) { pointer in
                UnsafeBufferPointer(start: pointer, count: count)
            }
        }

        return Array(bytesPointer)
    }

}
