//
//  Currency.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 26.06.2021.
//

enum Currency: String {
    case uah = "₴"
    case usd = "$"
    case eur = "€"
    
    static let allCases = [uah, usd, eur]
}
