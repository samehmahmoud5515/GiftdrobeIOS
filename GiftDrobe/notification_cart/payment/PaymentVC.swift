//
//  PaymentVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/27/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class PaymentVC: BaseViewController {

    @IBOutlet var api : PaymentsAPI!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    var amount : String = "100"
    var deliveryFees : String = "6000"
    var moneySubmittedListener: MoneySubmitted?
    var loadCard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.messageView.isHidden = true
        let userManager = UserDataManager()
        let mail = userManager.getUserMail()
        
        let total_amount = amount.floatValue  + deliveryFees.floatValue
        let fractionalA:Float = amount.floatValue.truncatingRemainder(dividingBy: 1)
        let fractionalD:Float = deliveryFees.floatValue.truncatingRemainder(dividingBy: 1)

        let fractional: Float = fractionalA + fractionalD
        let fractional_app = String(format: "%.2f", fractional)
        
        var total_amount_str: String = "100"
        if fractional > 0 {
             total_amount_str = String(Int(total_amount)) + String(fractional_app.floatValue * 100) }
        else {
                total_amount_str = String(Int(total_amount)) + "00"
        }
        total_amount_str = total_amount_str.replacingOccurrences(of: ".0", with: "")
        let mer_ref: Int = Int(arc4random() % 10) + Int(arc4random_uniform(10000)) ;
        self.startActivityIndicator()
        
        self.api.getSDKToken(completion: {
         json in
         
         self.stopActivityIndicator()
         if json?.response_code == "22000" {
            
        DispatchQueue.main.async {
         let userManager = UserDataManager()
         let tokenName = userManager.getToken_name()
         let payFort = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
         
         let request = NSMutableDictionary.init()
         request.setValue( total_amount_str , forKey: "amount")
         request.setValue("AUTHORIZATION", forKey: "command")
         request.setValue("EGP", forKey: "currency")
         request.setValue(mail, forKey: "customer_email")
         request.setValue("en", forKey: "language")
         request.setValue(mer_ref, forKey: "merchant_reference")
         request.setValue( json?.sdk_token , forKey: "sdk_token")
         
         if tokenName != "" {
            if self.loadCard {
                request.setValue(tokenName , forKey: "token_name") }
            }
         
         payFort?.callPayFort(withRequest: request, currentViewController: self, success: { (requestDic, responeDic) in
            print("success0000")
            let token_name: String? = responeDic?["token_name"] as? String
            userManager.saveToken_name(token_name: token_name ?? "")
            let mer_ref: String? = responeDic?["merchant_reference"] as? String
            userManager.saveMerchantRef (merchant_ref: mer_ref ?? "")
            print("responeDic=\(String(describing: responeDic))" )
            self.messageView.isHidden = false
            self.messageLabel.text = "Transaction Successed"
            self.messageView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
            self.view.addSubview(self.messageView)
            self.backToCart()
         },canceled: { (requestDic, responeDic) in
         
         print("canceled")
            
            self.messageView.isHidden = false
            self.messageLabel.text = "Transaction Canceled press top back button to return to shopping cart"
            self.messageView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
            self.view.addSubview(self.messageView)
            
         },faild: { (requestDic, responeDic, message) in
         print("faild")
            print("responeDic=\(String(describing: responeDic))" )
            print("message=\(String(describing: message))" )
            self.messageView.isHidden = false
            self.messageLabel.text = "Transaction Failed press top back button to return to shopping cart"
            self.messageView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
            self.view.addSubview(self.messageView)
         })
         
            payFort?.isShowResponsePage = true;
            }
         }
           
            
         })
        
    }
    
    func backToCart () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.popToRootViewController(animated: true)
            self.moneySubmittedListener?.onMoneySubmitted()
        }
    }

    
}



protocol MoneySubmitted {
    func onMoneySubmitted()
}



