//
//  CoinListCell.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit

class CoinListCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var nameLbl: UILabel!
    
    func configCell(coin: coinTuple) {
        nameLbl.text = coin.name
    }

}
