//
//  WrappingSelectionViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingSelectionViewModel: NSObject {
    
    @IBOutlet var api : WrappingSelectionAPI!
    var json : WrappingSelectionJson?
    
    func requestItems (id: String ,giftId : String , completion: @escaping (Bool?) -> ()) {
        api.fetchData(giftId: giftId, id: id ,compeletion: {
            json  in
            if json == nil {
                completion(false)
            }
            if json?.wrapping_success == 1 {
                self.json = json
                completion (true)
            } else {
                completion (false)
            }
            
        })
        
    }
    
    func getListCount () -> Int
    {
        return json?.wrapping?.count ?? 0
    }
    func getSelction (indexPath: IndexPath) -> WrappingSelection {
        return (json?.wrapping?[indexPath.row])!
    }
}
