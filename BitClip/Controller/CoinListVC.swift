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
    var selectedCoin: coinTuple!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CoinListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return CoreData.instance.userCoins.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinListCell") as? CoinListCell else {return UITableViewCell()}
        
        if isSearching {
            selectedCoin = (name: filteredData[indexPath.row], "", "", "")
        } else {
            selectedCoin = (
                CoreData.instance.userCoins[indexPath.row].name,
                CoreData.instance.userCoins[indexPath.row].price,
                CoreData.instance.userCoins[indexPath.row].percentChange,
                CoreData.instance.userCoins[indexPath.row].comparedTo
                ) as! coinTuple
        }
        
        cell.configCell(coin: selectedCoin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredData.isEmpty {
            //save coin to coredata
            selectedCoin = BinanceService.instance.getSingleCoinData(coinName: filteredData[indexPath.row])
            CoreData.instance.saveToPhone(selectedCoin: selectedCoin, completion: { (complete) in
                if complete {
                    self.searchBar.text = ""
                    self.isSearching = false
                    self.filteredData.removeAll()
                    self.view.endEditing(true)
                    CoreData.instance.fetchCoins(spinner: nil)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            CoreData.instance.removeCoin(atIndexPath: indexPath)
            CoreData.instance.fetchCoins(spinner: nil)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
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
            filteredData =
               BinanceService.instance.allCoinNames.filter({$0.hasPrefix(searchBar.text!)})
            tableView.reloadData()
        }
    }
}
