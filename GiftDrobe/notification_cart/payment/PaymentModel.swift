//
//  PaymentModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct GetSDKTokenJson: Decodable {
    var response_code: String?
    var response_message: String?
    var sdk_token: String?
    var signature: String?
    var merchant_identifier: String?
    var device_id: String?
    var access_code: String?
}

struct GetTokenNameJson: Decodable {
    var token_name: String?
}
