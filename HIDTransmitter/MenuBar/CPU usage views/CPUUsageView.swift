//
//  CPUUsageView.swift
//  HIDTransmitter
//
//  Created by Maxime Bokobza on 23/11/2023.
//

import SwiftUI

private extension CGFloat {

    static let unitMargin: CGFloat = 2
    static let unitSize: CGFloat = 4

}

struct CPUUsageView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: .unitMargin) {
            ForEach(0..<usage.count, id: \.self) { index in
                CPUUsageComponent(value: usage[index])
            }
        }
    }

    private var usage: [UInt8]

    init(_ usage: [UInt8]) {
        self.usage = usage
    }

}

struct CPUUsageComponent: View {

    var body: some View {
        HStack(spacing: .unitMargin) {
            Rectangle()
                .frame(width: 1, height: .unitSize)
                .opacity(0.5)

            ForEach(0..<value, id: \.self) { index in
                Rectangle()
                    .frame(width: .unitSize, height: .unitSize)
            }
        }
    }

    private let value: Int

    init(value: UInt8) {
        self.value = Int(round(Float(value) / 5))
    }

}
