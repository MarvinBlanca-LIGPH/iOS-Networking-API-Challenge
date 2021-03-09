//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ bitcoinRate: BitcoinRateData)
    func didFailWithError(_ error: Error)
}
struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "825D8232-4FAE-4815-B841-03163087EE36"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performReqest(urlString)
    }
    
    func performReqest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinRate = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRate(bitcoinRate)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> BitcoinRateData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BitcoinRateData.self, from: weatherData)
            let id = decodedData.asset_id_base
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let bitcoinRate = BitcoinRateData(asset_id_base: id, asset_id_quote: currency, rate: rate)
            return bitcoinRate
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }

}
