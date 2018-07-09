//
//  SingleFlowerViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/24/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SingleFlowerViewModel: NSObject {

    @IBOutlet var api : SingleFlowerAPI!
    var flowers : [SingleFlower]? = [] 
    
    func rquestFlowersList (limit: Int , page: Int , compeletion : @escaping (Bool?) ->() ) {
        api.getFlowersListFromApi(limit: String(limit), page: String(page), compeletion: {
            json in
            if json == nil && json?.flowers == nil {
                compeletion(true)
                return
            }
            if json?.flowers_success == 1 {
                if let arr : [SingleFlower] = json?.flowers{
                    for g in arr {
                        self.flowers?.append(g)
                    }
                }
                compeletion(true)
            } else {
                compeletion(false)
            }
        })
    }
    
    func getLitCount () -> Int {
        return flowers?.count ?? 0
    }
    
    func getFlower (indexPath: IndexPath ) -> SingleFlower {
        return flowers![indexPath.row]
    }
    
    func clearData()
    {
        flowers = []
    }
}


