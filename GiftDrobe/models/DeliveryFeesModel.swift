//
//  DeliveryFeesJson.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/16/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct DeliveryFeesJson : Decodable {
    var fees: String?
    var apple_payment: Int?
    var success: Int?
}
