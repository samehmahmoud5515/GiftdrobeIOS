//
//  NotificationAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class NotificationAPI: NSObject {

    func fetchNotificatioData(limit: String, page : String,compeletion: @escaping (NotificationJson?) -> ())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["1":"1"
            ], pathparam: "notificationAPI.php")
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
                
                let recentModel = try JSONDecoder().decode(NotificationJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}


