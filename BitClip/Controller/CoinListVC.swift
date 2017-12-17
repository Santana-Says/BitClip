//
//  CoinListVC.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit
import CoreData

class CoinListVC: UIViewController {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var isSearching = false
    var filteredData: [String] = []
    var coinName = ""
    var comparisonCoin: ComparisonCoinType = .btc
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func saveToPhone(completion: @escaping CompletionHandler) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let coin = Coin(context: managedContext)
        
        coin.name = coinName
        coin.comparedTo = setComparisonCoin(coin: coinName).rawValue
        
        do {
            try managedContext.save()
            print("Saved")
            completion(true)
        } catch {
            completion(false)
        }
    }
}

extension CoinListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinListCell") as? CoinListCell else {return UITableViewCell()}
        
        if !isSearching {
            coinName = filteredData[indexPath.row]
        } else {
            coinName = BinanceService.instance.coins[indexPath.row]
        }
        
        cell.configCell(name: coinName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredData.isEmpty {
            //save coin to coredata
            coinName = filteredData[indexPath.row]
            saveToPhone(completion: { (complete) in
                if complete {
                    self.searchBar.text = ""
                    self.isSearching = false
                    self.view.endEditing(true)
                }
            })
        }
    }
}

extension CoinListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text ?? "").isEmpty {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = BinanceService.instance.coins.filter({$0.hasPrefix(searchBar.text!)})
            tableView.reloadData()
        }
    }
}
