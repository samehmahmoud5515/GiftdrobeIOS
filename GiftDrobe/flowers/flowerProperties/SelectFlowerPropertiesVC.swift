//
//  SelectFlowerPropertiesVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages

class SelectFlowerPropertiesVC: UIViewController , radioButtonClickedTableDelegate{
    
    var count:Int = 1
    
    @IBOutlet weak var total_price_label: UILabel!
    @IBOutlet weak var flower_price_label: UILabel!
    @IBOutlet weak var flower_name_label: UILabel!
    @IBOutlet weak var count_label: UILabel!
    var customFlowerAddProtocol : SetSelectedFlower? = nil
    
    var flowerPriceInt : Float?
    var totalPriceInt : Float = 0
    var flower: SingleFlower!
    var selectedColor: String = ""
    
    func radioButtunClickedInTable(button: PVRadioButton) {
        print(button.titleLabel?.text ?? "")
        selectedColor = button.titleLabel?.text ?? ""
    }
    
    
    @IBOutlet weak var radioGroup: PVRadioButtonView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        radioGroup.delegate = self
        var colors : [String] = []
       
        if let  flowerColors = flower.color {
            if flowerColors.count > 1 {
            for c in flowerColors {
                colors.append(c.name ?? "")
            }
            radioGroup.addButtons(radioButtonTitles: colors)
            }
        }
        
        if let flowerName = flower.name {
            flower_name_label.text = flowerName
        } else {
            flower_name_label.isHidden = true
        }
        if let flowerPrice = flower.price {
            flower_price_label.text = flowerPrice + " EGP"
            let f_price = flowerPrice.floatValue
            flowerPriceInt = f_price
            total_price_label.text = flowerPrice  + " EGP"
        }else {
            flower_price_label.isHidden = true
            flowerPriceInt = 0
        }
        
    }
    
    @IBAction func submit_btn_action(_ sender: Any) {
        if selectedColor != "" {
            flower.quantity = count
            if let flowerCount = flower.color?.count {
            for  i in 0...flowerCount-1 {
                if selectedColor == flower.color![i].name {
                     flower.selectedColor = i
                    customFlowerAddProtocol?.setSelectedFlower(singleFlower: flower)
                    self.performSegueToReturnBack()
                    self.performSegueToReturnBack()
                }
            }
        }
        }else {
            // show error Message
            self.colorFailed()
        }
    }
    
    func colorFailed(msg: String = "please select one color to submit flower")
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

    @IBAction func increment_btn_action(_ sender: Any) {
        if count >= 1
        {
            count = count + 1
            count_label.text = String (count)
            totalPriceInt = Float(count) * flowerPriceInt!
            total_price_label.text = String(describing: totalPriceInt) + " EGP"
        }
    }
    
    @IBAction func decrement_btn_action(_ sender: Any) {
        if count > 1
        {
            count = count - 1
            count_label.text = String (count)
            totalPriceInt = Float(count) * flowerPriceInt!
            total_price_label.text = String(describing: totalPriceInt) + " EGP"
        }
    }
}
protocol SetSelectedFlower {
    func setSelectedFlower (singleFlower : SingleFlower)
}


