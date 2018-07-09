//
//  ProductDetailsViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProductDetailsViewModel: NSObject {

    @IBOutlet var api: ProductDetailsAPI!
    var productJson: ProductDetailsJson?
    func getProductDetails (produtId: String , compeletion: @escaping (Gift?) -> () ){
        
        api.fetchProductDetails(productId: produtId, compeletion: {
            product_json in
            self.productJson = product_json
            if product_json != nil
            {
            if product_json?.gift_success == 1
            {
                self.api.callSeenAPI(productId: produtId)
                compeletion(product_json?.gifts![0])
            }
            else{
                compeletion(nil)
            }
            }else {
                compeletion(nil)
            }
        })
    }
    func getGiftImage(indexPath: IndexPath ) -> String {
        return productJson?.gifts?[0].images![indexPath.row] ?? ""
    }
    func getNumberOfProductImages ()-> Int {
        return productJson?.gifts?[0].images?.count ?? 0
    }
    
    func getProductId (indexPath: IndexPath) -> String {
        return (productJson?.gifts?[0].other_gifts![indexPath.row])!.id!
    }
    
    func getOtherGiftsSize() -> Int {
        return productJson?.gifts?[0].other_gifts?.count ?? 0
    }
    func getOtherGifts(indexPath: IndexPath)-> OtherGift {
        return (productJson?.gifts?[0].other_gifts![indexPath.row])!
    }
}
