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
    
    private func fetchCoreData(completion: @escaping CompletionHandler) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coin")
        
        do {
            CoreData.instance.userCoins = try managedContext?.fetch(fetchRequest) as! [Coin]
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func fetchCoins() {
        self.fetchCoreData { (complete) in
            if complete {
                BinanceService.instance.getCoinTrades(completion: { (complete) in
                    if complete {
                        
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
