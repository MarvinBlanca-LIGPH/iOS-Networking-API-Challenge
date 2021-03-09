//
//  BitcoinRate.swift
//  ByteCoin
//
//  Created by Mark Marvin Blanca on 3/9/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct BitcoinRateData : Codable{
    var asset_id_base: String
    var asset_id_quote: String
    var rate: Float
}
