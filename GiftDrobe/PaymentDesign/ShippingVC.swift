//
//  ShippingVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/11/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ShippingVC: UIViewController {

    var deliveryFees = ""
    var total_price = ""
    var  net_price = Float(0)
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var price_label_top: UILabel!
    @IBOutlet weak var shippingFee_label_top: UILabel!
    @IBOutlet weak var shippingAddress_label: UILabel!
    @IBOutlet weak var stackView: UIStackView!

   override func viewDidLoad() {
        super.viewDidLoad()
        net_price = total_price.floatValue + deliveryFees.floatValue
        self.price_label.text = "Total price: " + String(net_price) + "EGP"
        self.price_label_top.text = "Total price: " + String(net_price) + "EGP"
        self.shippingFee_label_top.text = "Delivery Fees: " + deliveryFees + "EGP"
    }
    
    @IBAction func nextAction() {
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            tabBarItem1.isEnabled = true
            tabBarItem2.isEnabled = true
            tabBarItem3.isEnabled = true
        }
        tabBarController?.selectedIndex = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let viewWithTag = self.tabBarController?.view.viewWithTag(100001) {
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
                priceTextLabel.text = "Total price: " + String(net_price) + "EGP"
                priceTextLabel.numberOfLines = 2
                
                let stackView   = UIStackView(frame: CGRect(x: 0, y: (deviceHeight - 113), width: deviceWidth, height: 50))
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.fill
                stackView.spacing   = 0.0
                stackView.tag = 100002
                
                stackView.addArrangedSubview(priceTextLabel)
                stackView.addArrangedSubview(button)
                
                
                tabBarController.view.addSubview(stackView)
                
            }
        }
        
    }
    
}
