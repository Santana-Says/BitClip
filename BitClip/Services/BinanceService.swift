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
    
    var bitData: Data!
    var allCoinNames: [String] = []
    
    
    func getAllCoinData(completion: @escaping CompletionHandler) {
        Alamofire.request(TICKER_URL).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.bitData = data
                self.coinParser(data: self.bitData)
                
                if self.allCoinNames.count > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func coinParser(data: Data) {
        let json = JSON(data)
        for info in json.arrayValue {
            let name = info["symbol"].stringValue
            
            //update the user coins
            if let coinIndex = CoreData.instance.userCoins.index(where: {$0.name == name}) {
                let userCoins = CoreData.instance.userCoins
                userCoins[coinIndex].price = info["bidPrice"].stringValue
                userCoins[coinIndex].percentChange = info["priceChangePercent"].stringValue
            } else {
                allCoinNames.append(name)
            }
        }
    }
    
    func getSingleCoinData(coinName: String) -> coinTuple {
        let json = JSON(bitData)
        var coin: coinTuple = ("","","","")
        for info in json.arrayValue {
            let cName = info["symbol"].stringValue
            
            
            if cName == coinName{
                coin.name = cName
                coin.price = info["bidPrice"].stringValue
                coin.percentChange = info["priceChangePercent"].stringValue
                coin.compareCoin = setComparisonCoin(coin: cName).rawValue
                //completion(true)
                return coin
            }
        }
        //completion(false)
        return coin
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
