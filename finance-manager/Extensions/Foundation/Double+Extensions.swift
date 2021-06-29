//
//  Double+Extensions.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 29.06.2021.
//

private extension String {
    static let doubleFormat = "%.2f"
}

extension Double {
    var clippedToString: String {
        return String(format: .doubleFormat, self)
    }
}
