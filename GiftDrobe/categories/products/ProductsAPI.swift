//
//  ProductsAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProductsAPI: NSObject {

    func fetchProductList (limit: String , page: String , catId: String,compeletion: @escaping (ProductJson?)->())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["category_id" : catId , "page" : page , "limit" : limit
            ], pathparam: "itemsByCategoryAPI.php")
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
                
                let products = try JSONDecoder().decode(ProductJson.self, from: data)
                compeletion (products)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)

            }
            
            }.resume()
    }
}
/*
 https://logic-host.com/work/gift/phpFiles/itemsByCategoryAPI.php?key=logic123&category_id=1&page=1&limit=2&age=1998-02-09&type=1&from=10&to=250
 */
