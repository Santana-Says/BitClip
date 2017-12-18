//
//  Constants.swift
//  BitClip
//
//  Created by Jeffrey Santana on 12/16/17.
//  Copyright © 2017 Jefffrey Santana. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as? AppDelegate
let managedContext  = appDelegate?.persistentContainer.viewContext

typealias CompletionHandler = (_ Success: Bool) -> ()
typealias coinTuple = (name: String, price: String, percentChange: String, compareCoin: String)

//URLs
let BASE_URL = "https://api.binance.com"
let TICKER_URL = BASE_URL + "/api/v1/ticker/24hr"

