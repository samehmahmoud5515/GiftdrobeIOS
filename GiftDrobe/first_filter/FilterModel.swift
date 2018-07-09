//
//  FilterModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct OccasionJson : Decodable {
    var occasion_success : Int?
    var occasions: [OccasionItem]?
}

struct OccasionItem :Decodable  {
    var id : String?
    var occasion: String?
}

struct RelationJson : Decodable {
    var relations_success : Int?
    var relations : [RelationItem]?
}

struct RelationItem : Decodable {
    var id: String?
    var relations : String?
}
