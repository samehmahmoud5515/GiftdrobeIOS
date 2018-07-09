//
//  ProductDetailsModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct ProductDetailsJson : Decodable
{
    var gift_success: Int?
    var gifts: [Gift]?
}

struct Gift : Decodable
{
    var id: String?
    var name: String?
    var price: String?
    var category_name : String?
    var description: String?
    var quantity: String?
    var images: [String]?
    var time: String?
    var category_id: String?
    var supplier: String?
    var brand: String?
    var other_gifts: [OtherGift]?

}

struct OtherGift : Decodable {
    var id: String?
    var name: String?
    var price: String?
    var image: String?
}


