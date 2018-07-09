//
//  CategoriesDialogServiceAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CategoriesDialogServiceAPI: NSObject {

    func fetchData(compeletion : @escaping ( CategoriesDialogAPI? ) -> () )  {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlString = "https://logic-host.com/work/gift/phpFiles/getCategoriesAPI.php?key=logic123"
        guard  let url = URL (string: urlString) else {return}
        
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
                
                let cat_api = try JSONDecoder().decode(CategoriesDialogAPI.self, from: data)
                compeletion (cat_api)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
        
    }
    
    func submitFilter (catIds : [String]
        ,completion : @escaping (Bool?) -> () ) {
        
      //  URLQueryItem(name: "data", value: "[cats:[1 , 2  ]]" )
        
        var postString = "key=logic123&&update_flag=1&data={\"cats\":["
        for i in 0..<catIds.count{
            postString += "\"" + catIds[i] + "\""
            if i != catIds.count - 1 {
                postString += ","
            }
        }
        
       
        postString += "]}"
        let url = URL(string: "https://logic-host.com/work/gift/phpFiles/filterAPI.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        print ("POST STR", postString)
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completion(false)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            completion(true)
            
            }.resume()
    }
}
