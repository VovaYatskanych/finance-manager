//
//  WalletCollectionViewCell.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 26.06.2021.
//

import UIKit

private extension CGFloat {
    static let cornerRadius: CGFloat = 10
}

final class WalletCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = .cornerRadius
    }
}
