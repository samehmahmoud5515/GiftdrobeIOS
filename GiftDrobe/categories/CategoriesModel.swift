//
//  CategoriesModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/2/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
public struct CategoriesModel: Decodable {
    
    let id : String?
    let name : String?
    let type : String?
    let icon : String?
    
}

public struct OffersModel : Decodable
{
    let gift_id : String?
    let gift_name: String?
    let category_name: String?
    let price: String?
    let gift_image : String?
    let offer: String?
}

public struct HomeModel : Decodable
{
    let offers: [OffersModel]?
    let categories: [CategoriesModel]?
    let offer_success: Int?
    let categories_success: Int?
}

