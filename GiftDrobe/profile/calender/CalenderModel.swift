//
//  CalenderModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/26/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation


struct CalenderJson : Decodable {
  
    var events: [EventModel]?
    var success: Int?

  }



struct EventModel : Decodable {
 
    var ID: String
    var user_id: String?
    var relation: String?
    var occasion: String?
    var today : String?
    var year: String?
    var month: String?
    var day: String?
    var date: String?
    var relation_id: String?
    var occasion_id: String?
}

struct DeleteJson: Decodable {
    var success: Int?
}
