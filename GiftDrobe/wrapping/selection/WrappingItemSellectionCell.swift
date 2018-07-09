//
//  WrappingItemSellectionCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/26/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Kingfisher

class WrappingItemSellectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textViewBg: UIView!
    @IBOutlet weak var item_price: UILabel!
    @IBOutlet weak var item_iv: UIImageView!
    func displayContent( wrappingSelcection : WrappingSelection)
    {
        textViewBg.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        if let price = wrappingSelcection.price {
            item_price.text = price + " EGP"
        }
        if let wrappingImage = wrappingSelcection.image  {
            let url = URL(string: wrappingImage)
            let image = UIImage(named: "placeholder")
            item_iv.kf.setImage(with: url,placeholder: image)
        }
       
    }
    
    
}


