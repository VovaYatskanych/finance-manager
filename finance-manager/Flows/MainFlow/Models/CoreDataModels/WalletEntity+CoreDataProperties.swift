//
//  WalletEntity+CoreDataProperties.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 29.06.2021.
//
//

import CoreData

private extension String {
    static let walletEntityName = "WalletEntity"
}

extension WalletEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletEntity> {
        return NSFetchRequest<WalletEntity>(entityName: .walletEntityName)
    }

    @NSManaged public var amount: Double
    @NSManaged public var name: String
    @NSManaged public var currency: String
}

extension WalletEntity : Identifiable {
    var convertedCurrency: Currency {
        get { return Currency(rawValue: currency) ?? .uah}
        set { currency = newValue.rawValue }
    }
}
