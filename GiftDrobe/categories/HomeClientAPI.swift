//
//  HomeClientAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/2/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class HomeClientAPI: NSObject {

    func fetchData(compeletion : @escaping ( HomeModel? ) -> () )  {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["type" : "1"
            ], pathparam: "homeAPI.php")
        
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
           // let dataAsString = String(data: data, encoding: .utf8)
          //  print(dataAsString!)
            
            do {
                
                let homeModel = try JSONDecoder().decode(HomeModel.self, from: data)
                compeletion (homeModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
        }.resume()
        
    }
}
