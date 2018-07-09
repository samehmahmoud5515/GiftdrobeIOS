//
//  TrendingViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class TrendingViewModel: NSObject {

    @IBOutlet var api : TrendingAPI!
    var gifts : [RecentGift]? = []
    
    func clearData ()
    {
        self.gifts = []
    }
    func requestTrendingList ( limit: Int , page: Int , completion: @escaping (Bool?) -> ())
    {
      
        api.fetchTrendingList(limit : limit, page: page ,compeletion: {
            json in
            
            if json != nil{
            if json?.gift_success == 1
            {
                if let arr : [RecentGift] = json?.gifts{
                    for g in arr {
                        self.gifts?.append(g)
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
        return gifts?.count ?? 0
    }
    
    func getCategoriesName (indexPath: IndexPath) -> String
    {
        return gifts?[indexPath.row].name ?? ""
    }
    
    func getProductId (indexPath: IndexPath) -> String
    {
        return (gifts?[indexPath.row].gift_id) ?? "-1"
    }
    func getGift (indexPath: IndexPath) -> RecentGift? {
        if indexPath.row < (gifts?.count)!
            {return gifts?[indexPath.row] ?? nil}
        else {return nil}
    }
    
}
