//
//  SubmitOrderAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/11/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SubmitOrderAPI: NSObject {

    func getSDKToken(completion: @escaping (GetSDKTokenJson?) -> ()) {
        
        let payFort = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
        if let token = payFort?.getUDID() {
            let urlBuilder = URLs()
            
            let url = urlBuilder.createURLFromParameters(parameters: ["device_id": token
                ], pathparam: "getSDKtokenAPI.php")
            print (token)
            print(url)
            URLSession.shared.dataTask(with: url)
            {  (data, response , error) in
                
                if error != nil
                {
                    completion(nil)
                    return
                }
                
                guard let data = data else {return}
                
                
                do {
                    
                    let model = try JSONDecoder().decode(GetSDKTokenJson.self, from: data)
                    print(model)
                    completion (model)
                }catch let jsonErr {
                    print ("Error serializing json ", jsonErr)
                    completion(nil)
                }
                
                }.resume()
        }
    }
    
    func submitCart (userId:String ,  city: String ,country: String ,area: String ,address: String , paid: String,lat: String, lng: String,phone : String,orders: String,giftCard: String,
                     completion : @escaping (Bool?) -> () ) {
        
        
        var postString = "key=logic123&&user_id=" + userId + "&paid=" + paid
        
        if area != "" && address != "" && city != "" && country != "" {
            postString += "&area=" + area + "&address=" + address + "&city=" + city + "&country=" + country + "&" }
        else if lat != "" && lng != "" {
            postString += "&lat=" + lat + "&lng=" + lng + "&"
        }
        
        postString += "phone=" + phone + "&"
        
        
        postString += orders
        //"orders={\"orders\":[[[\"1\",\"g\"],[\"1\",\"c\",\"hiiii\"]],[[\"2\",\"g\"],[\"1\",\"w\"]]]}"
        postString += giftCard
        
        
        let url = URL(string: "https://logic-host.com/work/gift/phpFiles/orderAPI.php")!
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
              do {
            let model = try JSONDecoder().decode(OrderJson.self, from: data)
            if model.success == 1 {
                completion(true)
            } else {
                completion (false)
            }
              }catch let error as NSError {
                print(error.localizedDescription)
                completion (false)
            }
            
            }.resume()
    }
    
    func deleteToken (token: String ,merchant_reference: String ,completion : @escaping (Bool?) -> () ) {
        
        if !Reachability.shared.isConnectedToNetwork(){
            completion(nil)
        return
        }
        
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["token_name" : token , "merchant_reference" : merchant_reference
                                                                  
            ], pathparam: "deleteTokenName.php")
        
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                completion(nil)
                return
            }
            
            guard let data = data else {return}
          
            
            do {
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                completion(true)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                completion(nil)
            }
            
            }.resume()
    }
    
}

struct OrderJson: Decodable {
    var success: Int
}
