//
//  PremiumModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct PremiumJson : Decodable{
    var offers_success: Int?
    var offers: [OffersGift]?
}
