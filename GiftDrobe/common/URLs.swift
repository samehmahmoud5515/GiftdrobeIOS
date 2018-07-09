//
//  URLs.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct APIDetails {
    static let APIScheme = "https"
    static let APIHost = "logic-host.com"
    static let APIPath = "/work/gift/phpFiles/"
}

class URLs {


     func createURLFromParameters(parameters: [String:Any], pathparam: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = APIDetails.APIScheme
        components.host   = APIDetails.APIHost
        components.path   = APIDetails.APIPath
        if let paramPath = pathparam {
            components.path = APIDetails.APIPath + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
             let queryKey = URLQueryItem(name: "key", value: "logic123")
             components.queryItems!.append(queryKey)
        }
        
        return components.url!
    }
}

