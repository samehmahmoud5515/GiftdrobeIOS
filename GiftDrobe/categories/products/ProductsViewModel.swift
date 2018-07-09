//
//  ProductsViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProductsViewModel: NSObject {

    @IBOutlet var api : ProductsAPI!
    var gifts: [ProductGift]? = []
    
    func requestProductsList(limit: Int,page: Int,catId: String ,compeletion: @escaping (Bool?)->())
    {
        api.fetchProductList(limit : String (limit) ,page: String (page),catId: catId, compeletion: {
            product_json in
            if product_json?.gifts_success == 1
            {
                if let arr : [ProductGift] = product_json?.gifts{
                    for g in arr {
                        self.gifts?.append(g)
                    }
                }
                compeletion(true)
            }
            else {
                compeletion(false)
            }
        })
    }
    
    func numberOfItemsProductList () -> Int
    {
        return gifts?.count ?? 0
    }
    
    func getGift (indexPath: IndexPath) -> ProductGift
    {
        return (gifts?[indexPath.row]) ?? ProductGift()
    }
    
    func getProductId (indexPath: IndexPath) -> String
    {
        return (gifts?[indexPath.row].gift_id) ?? "-1"
    }
    func clearData ()
    {
        gifts = []
    }
    
}
