//
//  CartAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CartAPI: NSObject {

    func submitCart (userId:String ,  city: String ,country: String ,area: String ,address: String , paid: String,lat: String, lng: String,phone : String,orders: String, giftCard: String,
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
            completion(true)
            
            }.resume()
    }
    
    func getDeliveryFees(compeletion: @escaping (DeliveryFeesJson?) -> ())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["1":"1"
            ], pathparam: "getDeliveryFeesAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(DeliveryFeesJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
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
    
   
    
}
/*
https://logic-host.com/work/gift/phpFiles/getSDKtokenAPI.php?key=logic123&device_id=ffffffff-a9fa-0b44-7b27-29e70033c587 */
