//
//  BinanceService.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BinanceService {
    
    static let instance = BinanceService()
    
    var allCoins: [coinTuple] = []
    var allCoinNames: [String] = []
    
    
    func getCoinTrades(completion: @escaping CompletionHandler) {
        Alamofire.request(TICKER_URL).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.getCoinNames(data: data)
                
                if self.allCoins.count > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func getCoinNames(data: Data) {
        let json = JSON(data)
        for info in json.arrayValue {
            let name = info["symbol"].stringValue
            let coin = (
                name,
                info["lastPrice"].stringValue,
                info["priceChangePercent"].stringValue,
                setComparisonCoin(coin: name).rawValue
            )
            
            allCoins.append(coin)
            allCoinNames.append(name)
        }
    }
    
    func setComparisonCoin(coin: String) -> ComparisonCoinType {
        if coin.hasSuffix(ComparisonCoinType.btc.rawValue) {
            return ComparisonCoinType.btc
        } else if coin.hasSuffix(ComparisonCoinType.eth.rawValue) {
            return ComparisonCoinType.eth
        } else {
            return ComparisonCoinType.usdt
        }
    }
    
}
