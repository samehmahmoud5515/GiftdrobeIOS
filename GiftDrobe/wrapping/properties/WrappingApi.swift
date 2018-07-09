//
//  WrappingApi.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingApi: NSObject {

    func fetchData (cat_id: String, compeletion: @escaping (WrappingJson?) -> () ) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["type":cat_id], pathparam: "getWrappingAPI.php")
        print (url)
        URLSession.shared.dataTask(with: url){
            (data, response , error) in
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            do {
                
                let json = try JSONDecoder().decode(WrappingJson.self, from: data)
                compeletion (json)
             }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
        }
        
    }

