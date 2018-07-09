//
//  ProductDetailsAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProductDetailsAPI: NSObject {

    func fetchProductDetails (productId: String,compeletion: @escaping (ProductDetailsJson?)->())
    {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : productId
            ], pathparam: "getGiftByIdAPI.php")
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
                
                let product = try JSONDecoder().decode(ProductDetailsJson.self, from: data)
                compeletion (product)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func callSeenAPI (productId: String)
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : productId
            ], pathparam: "seenAPI.php")
        print (url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                return
            }
            guard let data = data else {return}
            do {
                
                _  = try JSONDecoder().decode(ProductDetailsJson.self, from: data)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
            }
            }.resume()
    }
}

/*
 https://logic-host.com/work/gift/phpFiles/seenAPI.php?key=logic123&id=1
 https://logic-host.com/work/gift/phpFiles/getGiftByIdAPI.php?key=logic123&id=1
 */
