//
//  CardModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct CardModel : Decodable{
    var id: String?
    var name: String?
    var image: String?
    var price: String?
}

struct CardJson : Decodable {
    var cards: [CardModel]?
    var success: Int?
}
