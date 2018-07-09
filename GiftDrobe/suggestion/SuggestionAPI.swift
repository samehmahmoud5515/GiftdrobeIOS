//
//  SuggestionAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SuggestionAPI: NSObject {
    func fetchRecentData(limit: String, page : String,compeletion: @escaping (RecentJson?) -> ())
    {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["type" : "1" , "limit" : limit , "page" : page
            ], pathparam: "suggestionAPI.php")
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
                
                let recentModel = try JSONDecoder().decode(RecentJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}
