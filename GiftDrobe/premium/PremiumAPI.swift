//
//  PremiumAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class PremiumAPI: NSObject {

    func getPremiumListFromApi (limit: String ,page: String ,compeletion : @escaping (PremiumJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: [ "limit": limit , "page" : page
            ], pathparam: "premiumAPI.php")
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
                
                let model = try JSONDecoder().decode(PremiumJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}
