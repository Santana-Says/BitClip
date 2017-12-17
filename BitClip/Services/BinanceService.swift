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
    var coins: [String] = []
    
    func getCoinTrades(completion: @escaping CompletionHandler) {
        Alamofire.request(TICKER_URL).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.setCoinInfo(data: data)
                
                if self.coins.count > 0 {
                    print("Coins saved")
                    print(self.coins)
                    completion(true)
                } else {
                    print("Failed to retreive coins")
                    completion(false)
                }
            }
        }
    }
    
    func setCoinInfo(data: Data) {
        let json = JSON(data)
        for coin in json.arrayValue {
            let name = coin["symbol"].stringValue
//            let price = coin["lastPrice"]
//            let percentChange = coin["priceChangePercent"]
            
            coins.append(name)
        }
    }
}
