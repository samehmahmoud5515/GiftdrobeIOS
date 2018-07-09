//
//  CardViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CardViewModel: NSObject {
    @IBOutlet var api : CardAPI!
    var cards : [CardModel]?
    func requestCardList (limit: Int , page: Int, compeletion : @escaping (Bool?) -> () )  {
        api.getCardListFromApi (limit: String(limit) , page: String(page), compeletion: {
            json in
            if json == nil || json?.cards == nil {
                compeletion(false)
            }
            if json?.success == 1 {
                self.cards = json?.cards
                compeletion(true)
            } else {
                compeletion(false)
            }
            
        })
    }
    
    func getNumberOfItemsInSection () -> Int {
        return cards?.count ?? 0
    }
    
    func getCard(indexPath: IndexPath) -> CardModel {
        return cards![indexPath.row]
    }
    
}
