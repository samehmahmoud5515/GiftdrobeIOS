//
//  SearchViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/30/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {

    @IBOutlet var api : SearchAPI!
    var gifts : [RecentGift]?
    func getList (word: String , compeletion: @escaping (Bool?) -> ()) {
        
        api.searchForGift (word: word , compeletion : {
            json in 
            if json == nil {
                compeletion(false)
            } else {
                if json?.gift_success == 1 {
                    self.gifts = json?.gifts
                    compeletion(true)
                } else {
                    compeletion(false)
                }
            }
            
        })
    }
    
    func numberOfSection() -> Int {
        return self.gifts?.count ?? 0
    }
    func getGift(indexPath: IndexPath) -> RecentGift {
        return (self.gifts?[indexPath.row])!
    }
    
    func getProductId (indexPath: IndexPath) -> String
    {
        return gifts?[indexPath.row].gift_id ?? "-1"
    }
    
}
