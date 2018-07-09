//
//  CardAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CardAPI: NSObject {

    
    func getCardListFromApi (limit: String ,page: String ,compeletion : @escaping (CardJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["1" : "1" ]//, "limit": limit , "page" : page
            , pathparam: "getCardAPI.php")
        
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(CardJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}


