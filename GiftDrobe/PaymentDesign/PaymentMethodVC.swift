//
//  PaymentMethodVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/11/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftMessages


class PaymentMethodVC: BaseViewController, RadioBtnDelgate , MoneySubmitted {

    @IBOutlet weak var cash_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var card_btn: RadioButton_!
    @IBOutlet weak var cash_btn: RadioButton_!
    @IBOutlet weak var payWithSavedCard_btn: RadioButton_!
    @IBOutlet weak var payWithSavedCard_label: UILabel!
    @IBOutlet weak var deletedSavedCard_btn: UIButton!
    @IBOutlet var api: SubmitOrderAPI!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var visa_iv: UIImageView!
    @IBOutlet weak var master_iv: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    var submitComp: SubmitCartCompeleted?
    var net_price = Float(0)

    var selectedType = ""
    var total_price = ""
    var deliveryFees = ""
    var orderStr = ""
    var giftCardStr = ""
    var isOpened = 1
    
    var country = "" , city = "" , area = "" , street = "" , phone = ""
    var lat = "" , long = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let viewWithTag = self.tabBarController?.view.viewWithTag(100001) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.tabBarController?.view.viewWithTag(100002) {
            viewWithTag.removeFromSuperview()
        }
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            // iphone x
            self.stackView.isHidden = false
        }else {
            self.stackView.isHidden = true
            if let tabBarController = self.tabBarController {
                let bounds = UIScreen.main.bounds
                let deviceHeight = bounds.size.height
                let deviceWidth = bounds.size.width
                
                let button = UIButton(frame: CGRect(x: 0, y: (deviceHeight - 113), width: deviceWidth, height: 50))
                button.backgroundColor = UIColor(hexString: "#DD3334")
                button.tintColor = .white
                button.setTitle("Next", for: .normal)
                button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)!
                button.addTarget(self, action:#selector(self.nextAction), for: .touchUpInside)
                
                let priceTextLabel = UILabel(frame: CGRect(x: 0, y: (deviceHeight - 113), width: deviceWidth, height: 50))
                priceTextLabel.backgroundColor = UIColor.white
                priceTextLabel.textColor = UIColor(hexString: "#DD3334")
                priceTextLabel.text  = "Hi World"
                priceTextLabel.textAlignment = .left
                priceTextLabel.font = UIFont(name: "Montserrat-Regular", size: 17)!
                priceTextLabel.text = "Total price: " + String(net_price) + "EGP"
                priceTextLabel.numberOfLines = 2
                
                let stackView   = UIStackView(frame: CGRect(x: 0, y: (deviceHeight - 113), width: deviceWidth, height: 50))
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.fill
                stackView.spacing   = 0.0
                stackView.tag = 100003
                
                stackView.addArrangedSubview(priceTextLabel)
                stackView.addArrangedSubview(button)
                
                
                tabBarController.view.addSubview(stackView)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cash_btn.delegate = self
        card_btn.delegate = self
        payWithSavedCard_btn.delegate = self
        cash_btn.name = "cash"
        card_btn.name = "card"
        payWithSavedCard_btn.name = "paySaved"
        //for_him_btn.buttonClicked(sender: for_him_btn)
        
        let cash_tab = UITapGestureRecognizer(target: self, action: #selector(self.cash_action))
        let cash_tab_ = UITapGestureRecognizer(target: self, action: #selector(self.cash_action))
        
        
        cash_label.addGestureRecognizer(cash_tab)
        cash_label.isUserInteractionEnabled = true
        
        let card_tab = UITapGestureRecognizer(target: self, action: #selector(self.card_action))
           let card_tab_ = UITapGestureRecognizer(target: self, action: #selector(self.card_action))
        
        card_label.addGestureRecognizer(card_tab)
        card_label.isUserInteractionEnabled = true
        cash_btn.addGestureRecognizer(cash_tab_)
        card_btn.addGestureRecognizer(card_tab_)

        
        let paySaved_tab = UITapGestureRecognizer(target: self, action: #selector(self.paySavedCard_action))
        let paySaved_tab_ = UITapGestureRecognizer(target: self, action: #selector(self.paySavedCard_action))
       
        payWithSavedCard_label.addGestureRecognizer(paySaved_tab)
        payWithSavedCard_label.isUserInteractionEnabled = true
        payWithSavedCard_btn.addGestureRecognizer(paySaved_tab_)

         net_price = total_price.floatValue + deliveryFees.floatValue
        self.price_label.text = "Total price: " + String(net_price) + "EGP"
        
        if isOpened == 1 {
            //hide
            self.master_iv.isHidden = true
            self.visa_iv.isHidden = true
            self.card_btn.isHidden = true
            self.card_label.isHidden = true
            self.payWithSavedCard_btn.isHidden = true
            self.payWithSavedCard_label.isHidden = true
            self.deletedSavedCard_btn.isHidden = true
         }else {
            self.master_iv.isHidden = false
            self.visa_iv.isHidden = false
            self.card_btn.isHidden = false
            self.card_label.isHidden = false
            self.payWithSavedCard_btn.isHidden = false
            self.payWithSavedCard_label.isHidden = false
            self.deletedSavedCard_btn.isHidden = false
            let userManager = UserDataManager()
            let tokenName = userManager.getToken_name()
            if tokenName == "" {
                payWithSavedCard_btn.isHidden = true
                payWithSavedCard_label.isHidden = true
                deletedSavedCard_btn.isHidden = true
            }else {
                payWithSavedCard_btn.isHidden = false
                payWithSavedCard_label.isHidden = false
                deletedSavedCard_btn.isHidden = false
            }
        }
        
       
    }

    func  onRadioBtnClicked(isChecked: Bool,name: String) {
        if name == "cash" && isChecked {
            selectedType = "cash"
        }else if name == "card" && isChecked {
            selectedType = "card"
        }else if name == "paySaved" && isChecked {
            selectedType = "paySaved"
        }
        print(selectedType)
    }
   
    @objc func cash_action() {
        if card_btn.isChecked {
            card_btn.buttonClicked(sender: card_btn)
        }
        if payWithSavedCard_btn.isChecked {
            payWithSavedCard_btn.buttonClicked(sender: payWithSavedCard_btn)
        }
        if cash_btn.isChecked == false {
            cash_btn.buttonClicked(sender: cash_btn)
        }
    }
    @objc func card_action() {
        if cash_btn.isChecked {
            cash_btn.buttonClicked(sender: cash_btn)
        }
        if payWithSavedCard_btn.isChecked {
            payWithSavedCard_btn.buttonClicked(sender: payWithSavedCard_btn)
        }
        if card_btn.isChecked == false {
            card_btn.buttonClicked(sender: card_btn)
        }
    }
    @objc func paySavedCard_action() {
        if payWithSavedCard_btn.isChecked == false {
            payWithSavedCard_btn.buttonClicked(sender: payWithSavedCard_btn)
        }
        if cash_btn.isChecked {
            cash_btn.buttonClicked(sender: cash_btn)
        }
        if card_btn.isChecked {
            card_btn.buttonClicked(sender: card_btn)
        }
    }
    
    func onMoneySubmitted() {
        self.startActivityIndicator()
        let userManagemnet = UserDataManager()
        self.api.submitCart(userId:userManagemnet.getUserId() ,  city: city ,country: country ,area: area ,address: area , paid: "1" ,lat: lat, lng: long, phone: phone,orders:  self.orderStr , giftCard: self.giftCardStr ,
                            completion : {success in
                                self.stopActivityIndicator()
             
                                if success == true {
                                    DispatchQueue.main.async {
                                        self.performSegueToReturnBack() }
                                        self.submitComp?.onSubmitCartCompleted()
                                }
                                else {
                                    DispatchQueue.main.async {
                                        self.orderFailed() }
                                }
        })
    }
    
    @IBAction func deleteSavedCard() {
        let userManagemnet = UserDataManager()
        let tokenName = userManagemnet.getToken_name()
        let mer_ref = userManagemnet.getMerchantRef()
            
        
            self.startActivityIndicator()

        api.deleteToken (token: tokenName  ,merchant_reference: mer_ref, completion: {
            _ in
            self.stopActivityIndicator()
        })
        
    }
    
    @IBAction func nextAction() {
        if selectedType == "cash" {
            self.startActivityIndicator()
            let userManagemnet = UserDataManager()
            self.api.submitCart(userId:userManagemnet.getUserId() ,  city: self.city ,country: self.country ,area: self.area ,address: self.street , paid: "0" , lat: lat, lng: long, phone: phone, orders:  self.orderStr, giftCard: self.giftCardStr ,
                                completion : {success in
                                    self.stopActivityIndicator()
                                        if success == true {
                                            DispatchQueue.main.async {
                                                self.performSegueToReturnBack()
                                            }
                                            self.submitComp?.onSubmitCartCompleted() }
                                    else {
                                            DispatchQueue.main.async {
                                                self.orderFailed() }
                                    }
            })
        } else if selectedType == "card" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            let fees = self.deliveryFees.floatValue
            newViewController.deliveryFees = String(Float(fees))
            newViewController.amount = String (self.total_price)
            newViewController.moneySubmittedListener = self
            self.navigationController?.pushViewController(newViewController, animated: true)
           
            
        } else if selectedType == "paySaved" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            let fees = self.deliveryFees.floatValue
            newViewController.deliveryFees = String(Float(fees))
            newViewController.amount = String (self.total_price)
            newViewController.moneySubmittedListener = self
            newViewController.loadCard = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else {
             DispatchQueue.main.async {
                self.payingFailed()
             }
        }
        
    }
    
    func payingFailed(msg: String = "Please select method for paying")
    {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .red
        self.view.makeToast( msg , duration: 3.0, position: .bottom, style: style)
    }
    
    func orderFailed(msg: String = "Order not submitted, please try again later")
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
}

protocol SubmitCartCompeleted {
    func onSubmitCartCompleted()
}
