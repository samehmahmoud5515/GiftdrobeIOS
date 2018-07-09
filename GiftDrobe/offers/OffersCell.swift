//
//  OffersCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/29/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Kingfisher

class OffersCell: UICollectionViewCell {
    
    @IBOutlet weak var product_iv: UIImageView!
    @IBOutlet weak var supplier_label: UILabel!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var product_name_label: UILabel!
    
    func displayContent(gift : OffersGift)
    {
        if let giftSupplier = gift.supplier{
            supplier_label.text = giftSupplier
        }
        
        if let giftPrice = gift.price{
            price_label.text = giftPrice + " EGP"
        }
        
        if let giftName = gift.gift_name {
            product_name_label.text = giftName
        }
        if let giftImage = gift.gift_image  {
            let url = URL(string: giftImage)
            let image = UIImage(named: "placeholder")
            product_iv.kf.setImage(with: url,placeholder: image)
        }
        
        
    }
}
