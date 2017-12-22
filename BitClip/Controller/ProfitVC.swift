//
//  ViewController.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/15/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit
import CoreData

class ProfitVC: UIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ComparisonSegControl: UISegmentedControl!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCoins()
    }
    
    func refreshCoins() {
        tableView.isHidden = true
        spinner.startAnimating()
        CoreData.instance.fetchCoreData { (complete) in
            if complete {
                BinanceService.instance.getAllCoinData(completion: { (complete) in
                    if complete {
                        CoreData.instance.updateCoinsOnPhone(completion: { (complete) in
                            if complete {
                                self.spinner.stopAnimating()
                                self.tableView.reloadData()
                                self.tableView.isHidden = false
                            } else {
                                print("Twas a Bust.....")
                            }
                        })
                    }
                })
            }
        }
    }

    @IBAction func ComparisonCoinPressed(_ sender: Any) {
    }
    
    @IBAction func viewSwpiedDown(_ sender: Any) {
        refreshCoins()
    }
}

extension ProfitVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreData.instance.userCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell") as? ProfitCell else {return UITableViewCell()}
        cell.configCell(
            name: CoreData.instance.userCoins[indexPath.row].name!,
            price: CoreData.instance.userCoins[indexPath.row].price!,
            change: CoreData.instance.userCoins[indexPath.row].percentChange!
        )
        return cell
    }
}
