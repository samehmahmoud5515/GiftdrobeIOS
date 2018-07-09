//
//  OffersViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class OffersViewModel: NSObject {

    
    @IBOutlet var api : OffersAPI!
    var offersGifts : [OffersGift]? = []
    func requestOffersList (limit: Int , page: Int ,completion: @escaping (Bool?) -> ())
    {
        api.fetchOffersList(limit: String (limit), page : String(page) ,compeletion: {
            json in
            
            if json != nil{
            if json?.offers_success == 1
            {
                if let arr : [OffersGift] = json?.offers{
                    for g in arr {
                        self.offersGifts?.append(g)
                    }
                }
                completion(true)
            }
            else {
                completion(false)
            }
            }
            else {
                completion(false)
            }
        })
    }
    
    func numberOfItemsInTrendingList ()-> Int
    {
        return offersGifts?.count ?? 0
    }
    
    func getCategoriesName (indexPath: IndexPath) -> String
    {
        return offersGifts?[indexPath.row].gift_name ?? ""
    }
    
    func getProductId (indexPath: IndexPath) -> String
    {
        return (offersGifts?[indexPath.row].gift_id) ?? "-1"
    }
    func getGift(indexPath: IndexPath) -> OffersGift
    {
        return (offersGifts?[indexPath.row])!
    }
    func clearData ()
    {
        self.offersGifts = []
    }
    
}
