//
//  OffersModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct OffersJson : Decodable
{
    let offers_success: Int
    let offers: [OffersGift]?
}

struct OffersGift : Decodable{
    var gift_id: String?
    var gift_name: String?
    var gift_image: String?
    var supplier: String?
    var price: String?
}
