//
//  PremiumViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class PremiumViewModel: NSObject {

    @IBOutlet var api: PremiumAPI!
    var gifts: [OffersGift]? = []
    func requestPremiumList (limit: Int ,page: Int,completion: @escaping (Bool?) -> ())
    {
        api.getPremiumListFromApi(limit : String(limit) ,page: String (page) ,compeletion: {
            premiumJson in
            if premiumJson == nil{
                completion(nil)
                return
            }
            if premiumJson?.offers_success == nil {
                 completion(false)
            }
            if premiumJson?.offers_success == 1 {
                if let arr : [OffersGift] = premiumJson?.offers{
                    for g in arr {
                        self.gifts?.append(g)
                    }
                }
                completion(true)
            }else {
                completion(false)
            }
            
        })
    }
    func numberOfItemInList () -> Int{
        return gifts?.count ?? 0
    }
    func getGift (indexPath: IndexPath) -> OffersGift{
        return gifts?[indexPath.row] ?? OffersGift()
    }
    func getGiftId(indexPath: IndexPath) -> String {
        return gifts?[indexPath.row].gift_id ?? "-1"
    }
    func clearData (){
        gifts = []
    }
}
