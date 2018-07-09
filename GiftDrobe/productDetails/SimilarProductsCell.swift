//
//  SimilarProductsCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SimilarProductsCell: UICollectionViewCell {
    
    @IBOutlet weak var pro_iv: UIImageView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var pro_view_bg: UIView!
    
    
    
    func displayContent(other: OtherGift)
    {
        pro_view_bg.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        name_label.text = other.name
        let img_replaced = other.image?.replacingOccurrences(of: " ", with: "%20")
        let url =  URL(string: img_replaced!)
        let image = UIImage(named: "placeholder")
        pro_iv.kf.setImage(with: url,placeholder: image)
    }
}
