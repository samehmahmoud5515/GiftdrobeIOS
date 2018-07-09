//
//  WrappingSelectionModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct WrappingSelectionJson : Decodable {
    var wrapping_success: Int?
    var wrapping : [WrappingSelection]?
}
struct WrappingSelection : Decodable {
    var id : String?
    var name : String?
    var image : String?
    var price : String?
    var supplier : String?
}
