//
//  MainViewController.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 25.06.2021.
//

import UIKit

private extension String {
    static let mainStoryboardName = "Main"
    static let mainViewControllerId = "mainViewController"
    static let walletNibName = "WalletCollectionViewCell"
    static let walletCellId = "walletCell"
    static let totalWealthLabelText = "Total wealth:"
    static let uahWealthLabelTest = "UAH: "
    static let usdWealthLabelTest = "USD: "
    static let eurWealthLabelTest = "EUR: "
    static let mainTitle = "Wallets"
    static let nameErrorAlertMessage = "Enter name of wallet!"
    static let amountErrorAlertMessage = "Incorrect amount. The amount must be greater than zero!"
    static let bigAmountMassage = "Too big amount!"
}

private extension Int {
    static let numberOfPickerViewComponents = 1
    static let maxAmountCharCount = 11
}

private extension Double {
    static let minAmountValue: Double = 0
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 10
}

final class MainViewController: UIViewController {
    
    @IBOutlet weak var addWalletButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var totalWealthLabel: UILabel!
    @IBOutlet weak var totalUahWealthLabel: UILabel!
    @IBOutlet weak var totalEurWealthLabel: UILabel!
    @IBOutlet weak var totalUsdWealthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var coordinator: MainCoordinator?
    private let walletService = WalletService()
    private var selectedCurrency: Currency = .uah
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func addWalletTapped() {
        guard let name = titleTextField.text,
              let amountString = amountTextField.text,
              amountString.count < .maxAmountCharCount else {
            presentAlert(message: .bigAmountMassage)
            return
        }
        
        if name.isEmpty {
            presentAlert(message: .nameErrorAlertMessage)
            return
        }

        guard let amount = Double(amountString), amount >= .minAmountValue else {
            presentAlert(message: .amountErrorAlertMessage)
            return
        }
        walletService.addWallet(Wallet(name: name, currency: selectedCurrency, amount: amount))
        self.collectionView.reloadData()
        titleTextField.text = nil
        amountTextField.text = nil
        updateTotalAmount()
    }
    
    private func setupUI() {
        title = .mainTitle
        updateTotalAmount()
        addWalletButton.layer.cornerRadius = .cornerRadius
        totalWealthLabel.text = .totalWealthLabelText
        collectionView.dataSource = self
        collectionView.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        let walletNib = UINib(nibName: .walletNibName, bundle: nil)
        collectionView.register(walletNib, forCellWithReuseIdentifier: .walletCellId)
    }
    
    private func updateTotalAmount() {
        self.walletService.totalAmount { uah, usd, eur  in
            self.totalUahWealthLabel.text = .uahWealthLabelTest + uah.clippedToString
            self.totalUsdWealthLabel.text = .usdWealthLabelTest + usd.clippedToString
            self.totalEurWealthLabel.text = .eurWealthLabelTest + eur.clippedToString
        }
    }
    
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        walletService.wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .walletCellId, for: indexPath) as! WalletCollectionViewCell
        
        let wallet = walletService.wallets[indexPath.row]
        cell.textLabel.text = wallet.name
        cell.amountLabel.text = wallet.amount.clippedToString + " " + wallet.currency.rawValue
        return cell
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        .numberOfPickerViewComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Currency.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currency.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = Currency.allCases[row]
    }
}

extension MainViewController {
    private static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: .mainStoryboardName, bundle: .main)
    }
    
    static func instantiateStatsViewController(coordinator: MainCoordinator) -> MainViewController {
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: .mainViewControllerId) as! MainViewController
        mainViewController.coordinator = coordinator
        return mainViewController
    }
}
