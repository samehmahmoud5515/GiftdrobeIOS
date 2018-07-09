//
//  BouquetViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/24/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class BouquetViewModel: NSObject {

    @IBOutlet var api :BouquetAPI!
    var bouquets :[BouquetItem]? = []
    
    func getBouquets (page: Int, limit : Int , compleletion: @escaping (Bool?) -> () ) {
        api.getBouquetListFromApi(limit : String(limit), page: String(page), compeletion: {
            json in
            if json == nil && json?.bouqets == nil {
                compleletion(false)
                return
            }
            if json?.bouqets_success == 1 {
                if let arr : [BouquetItem] = json?.bouqets{
                    for g in arr {
                        self.bouquets?.append(g)
                    }
                }
                compleletion (true)
            } else {
                compleletion (false)
            }
            
        } )
    }
    
    func getBouquetItemsCount () -> Int {
        return bouquets?.count ?? 0
    }
    
    func getBouquet (indexPath : IndexPath) -> BouquetItem {
        return bouquets![indexPath.row]
    }
    
    func getBouquet (indexPath : Int) -> BouquetItem {
        return bouquets![indexPath]
    }
    
    func getBouquetId (indexPath: Int) -> String {
        return bouquets?[indexPath].id ?? ""
    }
    
    func clearData()
    {
        bouquets = []
    }
    
    func buyBouquet (user_id: String , bouqet_id: String , schedule_id: String, message: String,cardId: String ,compeletion : @escaping (Bool?) -> () ) {
        api.buyBouquet(user_id:user_id,bouqet_id:bouqet_id,schedule_id:schedule_id, message:message,cardId: cardId ,compeletion: {
             json in
            if json == nil {
                compeletion(false)
            } else {
                if json?.success == 1 {
                    compeletion(true)
                } else {
                    compeletion(false)
                }
            }
            
        } )
    }
}
