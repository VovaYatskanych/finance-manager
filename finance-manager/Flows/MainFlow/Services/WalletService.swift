//
//  WalletService.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 27.06.2021.
//

import UIKit
import CoreData

private extension Double {
    static let initialValue: Double = 0
}

private extension String {
    static let persistentContainerName = "Finances"
    static let walletEntityName = "WalletEntity"
}

final class WalletService {
    
    private var walletArray: [Wallet] = []
    private var usdRate: Double = .initialValue
    private var eurRate: Double = .initialValue
    private var uahTotalAmount: Double = .initialValue
    private var usdTotalAmount: Double = .initialValue
    private var eurTotalAmount: Double = .initialValue
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: .persistentContainerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private lazy var managedContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()
    
    func addWallet(_ wallet: Wallet) {
        walletArray.append(wallet)
        saveWallets(wallet: wallet)
    }
    
    var wallets: [Wallet] {
        walletArray = []
        let fetchRequest = NSFetchRequest<WalletEntity>(entityName: .walletEntityName)
        if let result = try? self.managedContext.fetch(fetchRequest) as [WalletEntity] {
            for item in result {
                walletArray.append(Wallet(name: item.name, currency: item.convertedCurrency, amount: item.amount))
            }
        }
        return walletArray
    }
    
    func totalAmount(completion: @escaping (Double, Double, Double) -> Void) {
        DispatchQueue.global().async {
            self.getExchangeRate { [weak self] (usd, eur) in
                guard let self = self else { return }
                
                if let usd = usd, let eur = eur {
                    self.usdRate = usd
                    self.eurRate = eur
                }
                
                for wallet in self.walletArray {
                    self.toUah(wallet: wallet) { value in
                        self.uahTotalAmount += value
                    }
                    
                    self.toUsd(wallet: wallet) { value in
                        self.usdTotalAmount += value
                    }
                    
                    self.toEur(wallet: wallet) { value in
                        self.eurTotalAmount += value
                    }
                }
                
                DispatchQueue.main.async {
                    completion(self.uahTotalAmount, self.usdTotalAmount, self.eurTotalAmount)
                    self.uahTotalAmount = .initialValue
                    self.usdTotalAmount = .initialValue
                    self.eurTotalAmount = .initialValue
                }
            }
        }
    }
    
    private func saveWallets(wallet: Wallet) {
        guard let entity = NSEntityDescription.entity(forEntityName: .walletEntityName, in: self.managedContext) else { return }
        
        let model = WalletEntity(entity: entity, insertInto: self.managedContext)
        model.name = wallet.name
        model.convertedCurrency = wallet.currency
        model.amount = wallet.amount

        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func toUah(wallet: Wallet, completion: @escaping (Double) -> Void) {
        switch wallet.currency {
        case .eur:
            completion(wallet.amount * eurRate)
        case .usd:
            completion(wallet.amount * usdRate)
        case .uah:
            completion(wallet.amount)
        }
    }
    
    private func toUsd(wallet: Wallet, completion: @escaping (Double) -> Void) {
        switch wallet.currency {
        case .eur:
            completion(wallet.amount / (eurRate / usdRate))
        case .uah:
            completion(wallet.amount / usdRate)
        case .usd:
            completion(wallet.amount)
        }
    }
    
    private func toEur(wallet: Wallet, completion: @escaping (Double) -> Void) {
        switch wallet.currency {
        case .usd:
            completion(wallet.amount * (usdRate / eurRate))
        case .uah:
            completion(wallet.amount / eurRate)
        case .eur:
            completion(wallet.amount)
        }
    }
    
    private func getExchangeRate(completion: @escaping (Double?, Double?) -> Void) {
        CurrencyNetworkService.shared.getExchangeRate { data in
            guard !data.isEmpty, let usdRate = data[0].rateSell, let eurRate = data[1].rateSell else {
                completion(nil, nil)
                return
            }
            completion(usdRate, eurRate)
        }
    }
}
