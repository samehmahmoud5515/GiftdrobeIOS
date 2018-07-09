//
//  TrendingAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class TrendingAPI: NSObject {

    func fetchTrendingList ( limit: Int , page: Int ,compeletion : @escaping (RecentJson?) -> ())
    {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["limit" : String(limit) , "page" : String(page)
                                                                    ], pathparam: "trendingAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {
                compeletion(nil)
                return}
            
            
            do {
                
                let recentModel = try JSONDecoder().decode(RecentJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    
}



