//
//  bouquetModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/24/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct BouquetItem : Decodable {
    var id : String?
    var name: String?
    var number: String?
    var price : String?
    var image : String?
}
struct BouquetJson : Decodable {
    var bouqets : [BouquetItem]?
    var bouqets_success : Int?
}

struct BuyBouquetJson : Decodable {
    var success : Int?
}
