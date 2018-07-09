//
//  CardCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var card_iv: UIImageView!
    
    @IBOutlet weak var card_price_label: UILabel!
    
    @IBOutlet weak var card_view_bg: UIView!
    
 
    
    func displayContent(card: CardModel)
    {
        card_view_bg.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        if let cardImage = card.image  {
            let url = URL(string: cardImage)
            let image = UIImage(named: "placeholder")
            card_iv.kf.setImage(with: url,placeholder: image)
        }
        if let price = card.price {
            card_price_label.text = price + " EGP"
        }
    }
}
