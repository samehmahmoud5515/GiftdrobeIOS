//
//  WrappingModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct WrappingJson : Decodable {
    var wrapping_success: Int?
    var wrapping: [WrappingItem]?
}

struct WrappingItem : Decodable {
    var id: String?
    var name : String?
    var required: String?
    var selectedItem : WrappingSelection?
    var selectedName: String?
}
