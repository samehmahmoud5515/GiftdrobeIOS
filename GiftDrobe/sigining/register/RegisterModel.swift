//
//  RegisterModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct ResgisterJson : Decodable {
    var user: [User]?
    var success: Int?
}
