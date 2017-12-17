//
//  CoinListVC.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit

class CoinListVC: UIViewController {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var isSearching = false
    var filteredData: [String] = []
    var coin = ""
    
    
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
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinListCell") as? CoinListCell else {return UITableViewCell()}
        
        if filteredData.count > 0 {
            coin = filteredData[indexPath.row]
        } else {
            //coin =
        }
        cell.configCell(name: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredData.isEmpty {
            //save coin to coredata
        }
    }
}

extension CoinListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text ?? "").isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = BinanceService.instance.coins.filter({$0.hasPrefix(searchBar.text!)})
            tableView.reloadData()
        }
    }
}
