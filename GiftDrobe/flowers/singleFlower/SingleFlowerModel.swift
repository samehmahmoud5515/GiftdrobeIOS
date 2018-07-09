//
//  SingleFlowerModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/24/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct SingleFlowerJson : Decodable {
    var flowers_success: Int?
    var flowers: [SingleFlower]?
    
}

struct SingleFlower : Decodable {
    var id : String?
    var name: String?
    var price: String?
    var image: String?
    var color: [SingleFlowerColor]?
    var selectedColor : Int?
    var quantity : Int?
}
struct SingleFlowerColor : Decodable {
    var id: String?
    var name: String?
}
