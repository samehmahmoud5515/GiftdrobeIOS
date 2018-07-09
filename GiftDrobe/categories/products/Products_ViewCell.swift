//
//  Products_ViewCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Kingfisher

class Products_ViewCell: UICollectionViewCell {
   
    
    @IBOutlet weak var product_iv: UIImageView!
    @IBOutlet weak var supplier_label: UILabel!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var product_name_label: UILabel!
    
    
    func displayItem(gift: ProductGift)
    {
        if let giftSupplier = gift.supplier{
            supplier_label.text = giftSupplier
        }
        
        if let giftPrice = gift.price{
            price_label.text = giftPrice + " EGP"
        }
        
        if let giftName = gift.name {
            product_name_label.text = giftName
        }
        if let giftImage = gift.image  {
            let url = URL(string: giftImage)
            let image = UIImage(named: "placeholder")
            product_iv.kf.setImage(with: url,placeholder: image)
        }
    }
}
