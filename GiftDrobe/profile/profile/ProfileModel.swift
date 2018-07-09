//
//  ProfileModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/1/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
struct UserProfileJson : Decodable {
    var success: Int?
    var user: [UserJson]?
}
struct UserJson : Decodable {
    var id: String?
    var name: String?
    var password: String?
    var email: String?
    var mobile: String?
    var fullname: String?
    var sex: String?
    var age: String?
    var relationship: String?
    
}
