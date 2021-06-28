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
    static let totalWealthLabelText = "Total wealth: "
}

private extension Int {
    static let numberOfPickerViewComponents = 1
}

final class MainViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var totalWealthLabel: UILabel!
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
    
    func setupUI() {
        totalWealthLabel.text = .totalWealthLabelText
        collectionView.dataSource = self
        collectionView.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        let walletNib = UINib(nibName: .walletNibName, bundle: nil)
        collectionView.register(walletNib, forCellWithReuseIdentifier: .walletCellId)
    }
    
    @IBAction func addWalletTapped() {
        guard let name = titleTextField.text, let amountString = amountTextField.text else { return }
        guard let amount = Int(amountString) else { return }
        walletService.addWallet(Wallet(name: name, currency: selectedCurrency, amount: amount, transactions: []))
        self.collectionView.reloadData()
        titleTextField.text = nil
        amountTextField.text = nil
        totalWealthLabel.text = .totalWealthLabelText + String(walletService.totalAmount) + " " + Currency.uah.rawValue
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
        cell.amountLabel.text = String(wallet.amount) + " " + wallet.currency.rawValue
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
