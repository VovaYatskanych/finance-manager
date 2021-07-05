//
//  Double+Extensions.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 29.06.2021.
//

import Foundation

private extension String {
    static let doubleFormat = "%.2f"
    static let emptySpace = " "
}

extension Double {
    var clippedToString: String {
        let roundedNumber = String(format: .doubleFormat, self)
        guard let doubleNumber = Double(roundedNumber) else { return .emptySpace }
        let number = NSNumber(value: doubleNumber)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = .emptySpace
        let result = formatter.string(from: number) ?? .emptySpace
        return result
    }
}
