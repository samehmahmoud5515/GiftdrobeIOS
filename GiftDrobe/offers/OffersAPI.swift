//
//  OffersAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class OffersAPI: NSObject {

    
    func fetchOffersList (limit : String , page : String ,  compeletion : @escaping (OffersJson?) -> ())
    {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
       
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["type" : "1" , "limit": limit , "page": page
            ], pathparam: "offerAPI.php")
        print (url)
        
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
           
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {
                compeletion(nil)
                return}
            
            
            do {
                
                let recentModel = try JSONDecoder().decode(OffersJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}


/*

 */
