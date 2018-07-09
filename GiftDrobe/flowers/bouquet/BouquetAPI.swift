//
//  BouquetAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/24/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class BouquetAPI: NSObject {
    
    
    func getBouquetListFromApi (limit: String ,page: String ,compeletion : @escaping (BouquetJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: [ "limit": limit , "page" : page]
            , pathparam: "getBouqetsAPI.php")
        print (url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(BouquetJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    func buyBouquet (user_id: String , bouqet_id: String , schedule_id: String, message: String,cardId: String ,compeletion : @escaping (BuyBouquetJson?) -> () )
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["user_id" : user_id , "bouqet_id": bouqet_id, "schedule_id":schedule_id
            , "message": message]
            , pathparam: "buyBouqetAPI.php")
        
        print(url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(BuyBouquetJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}
/*
 https://logic-host.com/work/gift/phpFiles/buyBouqetAPI.php?key=logic123&user_id=1&bouqet_id=1&schedule_id=1
 */
