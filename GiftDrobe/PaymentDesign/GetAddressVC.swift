//
//  PaymentDetailsContainer.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift


class GetAddressVC: UIViewController , SubmitLocation {
    
    @IBOutlet weak var address_iv: UIImageView!
    @IBOutlet weak var gps_iv: UIImageView!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addressCardView: CardView!
    @IBOutlet weak var gpsCardView: CardView!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!


    
    var total_price = ""
    var country = "" , city = "" , area = "" , street = "" , phone = ""
    var lat = "" , long = ""

    func onLoactionSubmit(lat: String, long: String, phone: String) {
        self.lat = lat ; self.long = long ; self.phone = phone
        if let submitCont = self.tabBarController?.viewControllers?[2] as? PaymentMethodVC {
            submitCont.lat = lat
            submitCont.long = long
            submitCont.phone = phone
        }
        self.country = "" ; self.city = "" ; self.area = "" ; self.street = ""; self.phone = ""
        gpsCardView.backgroundColor = UIColor(hexString: "#DD3334")
        gpsLabel.textColor = UIColor.white
        gps_iv.image = #imageLiteral(resourceName: "gps_w")
        addressCardView.backgroundColor = UIColor.white
        addressLabel.textColor = UIColor(hexString: "#DD3334")
        address_iv.image = #imageLiteral(resourceName: "address")
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            tabBarItem1.isEnabled = true
            tabBarItem2.isEnabled = true
            tabBarItem3.isEnabled = false
        }
    }
    
    func onAddressSubmit(country: String, city: String, area: String, street: String, phone: String) {
         self.country = country ; self.city = city ; self.area = area ; self.street = street; self.phone = phone
        self.lat = "" ; self.long = ""
        if let submitCont = self.tabBarController?.viewControllers?[2] as? PaymentMethodVC {
            submitCont.country = country
            submitCont.city = city
            submitCont.area = area
            submitCont.street = street
            submitCont.phone = phone
        }
        gpsCardView.backgroundColor = UIColor.white
        gpsLabel.textColor = UIColor(hexString: "#DD3334")
        gps_iv.image = #imageLiteral(resourceName: "gps")
        addressCardView.backgroundColor = UIColor(hexString: "#DD3334")
        addressLabel.textColor = UIColor.white
        address_iv.image = #imageLiteral(resourceName: "address_w")
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            tabBarItem1.isEnabled = true
            tabBarItem2.isEnabled = true
            tabBarItem3.isEnabled = false
        }
    }
    
    @IBAction func nextAction() {
        if self.street == "" && self.long == "" {
            self.addressFailed()
        } else {
            if let viewWithTag = self.tabBarController?.view.viewWithTag(100001) {
                viewWithTag.removeFromSuperview()
            }
            tabBarController?.selectedIndex = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let viewWithTag = self.tabBarController?.view.viewWithTag(100002) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.tabBarController?.view.viewWithTag(100003) {
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
                priceTextLabel.text = "Total price: " + total_price + "EGP"
                priceTextLabel.numberOfLines = 2
                
                let stackView   = UIStackView(frame: CGRect(x: 0, y: (deviceHeight - 113), width: deviceWidth, height: 50))
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.fill
                stackView.spacing   = 0.0
                stackView.tag = 100001
                
                stackView.addArrangedSubview(priceTextLabel)
                stackView.addArrangedSubview(button)
                
                
                tabBarController.view.addSubview(stackView)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let address_tap = UITapGestureRecognizer(target: self, action: #selector(addressAction))
        address_iv.addGestureRecognizer(address_tap)
        address_iv.isUserInteractionEnabled = true
        
        let gps_tap = UITapGestureRecognizer(target: self, action: #selector(gpsAction))
        gps_iv.addGestureRecognizer(gps_tap)
        gps_iv.isUserInteractionEnabled = true
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            tabBarItem1.isEnabled = true
            tabBarItem2.isEnabled = false
            tabBarItem3.isEnabled = false
        }
        self.price_label.text = "Total price: " + total_price + "EGP"
        
        
       
    }
   
    
    @objc func addressAction() {
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        newViewController.listener = self
        self.present(newViewController, animated: true, completion: nil)
    }
    @objc func gpsAction() {
     
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController_nav") as! UINavigationController
        if let  child = newViewController.topViewController as? MapViewController {
            child.listener = self
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func addressFailed(msg: String = "Please select one of ways for getting the address")
    {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .red
        self.view.makeToast( msg , duration: 3.0, position: .bottom, style: style)
    }
}
