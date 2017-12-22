//
//  CoreData.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/17/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    static let instance = CoreData()
    
    public private(set) var userCoins: [Coin] = []
    
    func saveToPhone(selectedCoin: coinTuple, completion: @escaping CompletionHandler) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let coin = Coin(context: managedContext)
        
        coin.name = selectedCoin.name
        coin.price = selectedCoin.price
        coin.percentChange = selectedCoin.percentChange
        coin.comparedTo = selectedCoin.compareCoin
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func updateCoinsOnPhone(completion: @escaping CompletionHandler) {
        for userCoin in userCoins {
            userCoin.setValue(userCoin.price, forKey: "price")
            userCoin.setValue(userCoin.percentChange, forKey: "percentChange")
        }
        completion(true)
    }
    
    func fetchCoreData(completion: @escaping CompletionHandler) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coin")
        
        do {
            userCoins = try managedContext?.fetch(fetchRequest) as! [Coin]
            completion(true)
        } catch {
            print("Why tho")
            completion(false)
        }
    }
    
    func fetchCoins(spinner: UIActivityIndicatorView?) {
        CoreData.instance.fetchCoreData { (complete) in
            if complete {
                spinner?.isHidden = false
                spinner?.startAnimating()
                BinanceService.instance.getAllCoinData(completion: { (complete) in
                    if complete {
                        spinner?.stopAnimating()
                    }
                })
            }
        }
    }
    
    func removeCoin(atIndexPath indexPath: IndexPath) {
        managedContext?.delete(userCoins[indexPath.row])
        do {
            try managedContext?.save()
        } catch {
            
        }
    }
    
}
