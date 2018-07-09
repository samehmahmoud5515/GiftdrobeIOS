//
//  PaymentsAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/27/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class PaymentsAPI: NSObject {

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
