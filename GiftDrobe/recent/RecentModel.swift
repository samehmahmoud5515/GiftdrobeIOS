//
//  RecentModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/12/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation


struct RecentJson : Decodable {
    var gifts: [RecentGift]?
    var gift_success:Int?
}

struct RecentGift : Decodable {
    var gift_id : String?
    var image: String?
    var price: String?
    var supplier: String?
    var name: String?
}


