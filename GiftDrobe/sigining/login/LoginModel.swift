//
//  LoginModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct User: Decodable
{
    var id: String?
    var username: String?
    var password: String?
    var email: String?
    var mobile: String?
    var fullname: String?
    var sex: String?
    var age: String?
    var relationship: String?
}

struct LoginJson : Decodable
{
    var user: [User]?
    var success: Int?
}


