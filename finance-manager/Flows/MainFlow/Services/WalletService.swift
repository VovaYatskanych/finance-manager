//
//  WalletService.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 27.06.2021.
//

private extension Int {
    static let initialValue = 0
}

final class WalletService {
    private var walletArray: [Wallet] = []
    
    func addWallet(_ wallet: Wallet) {
        walletArray.append(wallet)
    }
    
    var wallets: [Wallet] {
        return walletArray
    }
    
    var totalAmount: Int {
        var amount: Int = .initialValue
        for wallet in walletArray {
            amount += wallet.amount
        }
        return amount
    }
}
