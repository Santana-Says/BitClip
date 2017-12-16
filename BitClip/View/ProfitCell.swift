//
//  ProfitCell.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit

class ProfitCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var coinPriceLbl: UILabel!
    @IBOutlet weak var coinChangeLbl: UILabel!
    
    func configCell(name: String, price: String, change: String) {
        coinNameLbl.text = name
        coinPriceLbl.text = price
        coinChangeLbl.text = "\(change)%"
    }

}
