//
//  CustomFlowersCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CustomFlowersCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labels_bg_view: UIView!
    @IBOutlet weak var flower_name_label: UILabel!
    @IBOutlet weak var quantity_label: UILabel!
    @IBOutlet weak var flower_iv: UIImageView!
    
    func displayContent(flower: SingleFlower)  {
        labels_bg_view.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        if let name = flower.name {
            flower_name_label.text = name
            if let s_color = flower.selectedColor  {
                flower_name_label.text = name + " (" + flower.color![s_color].name! + ")"
            }
        }
        if let quantity = flower.quantity {
            quantity_label.text = String(quantity)
        }
        
        if let flowerImage = flower.image  {
            let url = URL(string: flowerImage)
            let image = UIImage(named: "placeholder")
            flower_iv.kf.setImage(with: url,placeholder: image)
        }
        
    }
}
