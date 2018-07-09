//
//  CategoriesDialogModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

struct CategoriesDialogModel: Decodable {

    var id : String?
    var name: String?
    var icon :String?
    var type : String?
    
}

struct CategoriesDialogAPI: Decodable{
    var categories : [CategoriesDialogModel]?
    var categories_success: Int?
    var categories_message: String?
}


