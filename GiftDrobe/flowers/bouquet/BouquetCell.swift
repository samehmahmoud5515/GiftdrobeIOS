//
//  BouquetCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class BouquetCell: UICollectionViewCell {
    
    @IBOutlet weak var bouquet_iv: UIImageView!
    
    @IBOutlet weak var bouquet_price_label: UILabel!
    
    @IBOutlet weak var price_view_bg: UIView!
    
    func displayContent(bouquet : BouquetItem)
    {
        price_view_bg.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        if let giftImage = bouquet.image  {
            let url = URL(string: giftImage)
            let image = UIImage(named: "placeholder")
            bouquet_iv.kf.setImage(with: url,placeholder: image)
        }
        if let price = bouquet.price {
            bouquet_price_label.text = price + " EGP"
        }
    }
    
}
