//
//  SelcectFlowerCustomizeCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SelcectFlowerCustomizeCell: UICollectionViewCell {
    
    
    @IBOutlet weak var flower_name: UILabel!
    @IBOutlet weak var flower_price: UILabel!
    @IBOutlet weak var flower_iv: UIImageView!
    
    @IBOutlet weak var priceView_bg: UIView!
    
    func displayContent(flower : SingleFlower)
    {
        priceView_bg.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        if let name = flower.name {
            flower_name .text = name
        }
        if let price = flower.price {
            flower_price .text = price + " EGP"
        }
        if let giftImage = flower.image  {
            let url = URL(string: giftImage)
            let image = UIImage(named: "placeholder")
            flower_iv.kf.setImage(with: url,placeholder: image)
        }
    }
}
