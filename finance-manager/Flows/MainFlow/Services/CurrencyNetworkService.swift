//
//  CurrencyNetworkService.swift
//  finance-manager
//
//  Created by Volodymyr Yatskanych on 28.06.2021.
//

import Foundation

private extension String {
    static let baseURL = "https://api.monobank.ua/bank/currency"
}

final class CurrencyNetworkService {
    static let shared = CurrencyNetworkService()
    
    func getExchangeRate(completion: @escaping ([ExchangeRate]) -> Void) {
        guard let url = URL(string: .baseURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode([ExchangeRate].self, from: data)
                completion(decodedData)
            } catch {
                completion([])
            }
        }.resume()
    }
}
