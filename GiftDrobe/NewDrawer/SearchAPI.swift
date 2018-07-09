//
//  SearchAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/30/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SearchAPI: NSObject {
    
    func searchForGift (word: String,compeletion : @escaping (RecentJson?) -> ())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["search" : word
            ], pathparam: "searchAPI.php")
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

/*
 https://logic-host.com/work/gift/phpFiles/searchAPI.php?key=logic123&search=wat
 */
