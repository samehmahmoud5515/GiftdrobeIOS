//
//  SuggestionViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SuggestionViewModel: NSObject {
    var recent_gift : [RecentGift]? = []
    @IBOutlet var api :SuggestionAPI!
    func fetchRecentData (limit: Int, page : Int ,compeletion: @escaping (Bool?)->())
    {
        api.fetchRecentData(limit: String(limit) , page : String(page) ,compeletion: {
            recentJson in
            
            
            if recentJson != nil{
                if recentJson?.gift_success == 1{
                    if let arr : [RecentGift] = recentJson?.gifts{
                        for g in arr {
                            self.recent_gift?.append(g)
                        }
                    }
                    compeletion(true)
                }
                else{
                    compeletion(false)
                }
            }else {
                compeletion(false)
            }
            
        })
    }
    
    func numberOfItemsInCollectionView ()->Int
    {
        return recent_gift?.count ?? 0
    }
    
    func getCatName(indexPath: IndexPath) -> String
    {
        return recent_gift?[indexPath.row].name ?? ""
    }
    
    func getProductId (indexPath: IndexPath) -> String
    {
        return recent_gift?[indexPath.row].gift_id ?? "-1"
    }
    func getGift(indexPath: IndexPath) -> RecentGift
    {
        return (recent_gift?[indexPath.row])!
    }
    func clearData()
    {
        recent_gift = []
    }
}
