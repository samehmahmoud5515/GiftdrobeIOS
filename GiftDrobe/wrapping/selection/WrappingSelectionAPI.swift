//
//  WrappingSelectionAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingSelectionAPI: NSObject {
    func fetchData (giftId : String ,id : String,compeletion: @escaping (WrappingSelectionJson?) -> () ) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id": id , "gift_id" : giftId], pathparam: "getWrappingItemsAPI.php")
        print(url)
        URLSession.shared.dataTask(with: url){
            (data, response , error) in
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let json = try JSONDecoder().decode(WrappingSelectionJson.self, from: data)
                compeletion (json)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
}


