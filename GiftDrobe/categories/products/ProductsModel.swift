//
//  ProductsModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct ProductJson : Decodable {
    var gifts_success: Int?
    var gifts: [ProductGift]?
}

struct ProductGift : Decodable {
    
    var gift_id: String?
    var name: String?
    var seen: String?
    var bought_no: String?
    var image: String?
    var price: String?
    var supplier: String?
}
