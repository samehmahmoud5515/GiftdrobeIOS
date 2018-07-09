//
//  ProductDetailsImagesCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Kingfisher


class ProductDetailsImagesCell: UICollectionViewCell {
    @IBOutlet weak var product_iv: UIImageView!
    func displacContent(imageString:String)
    {
        let img_replaced = imageString.replacingOccurrences(of: " ", with: "%20")

        let url =  URL(string: img_replaced)
        let image = UIImage(named: "placeholder")
        product_iv.kf.setImage(with: url,placeholder: image)
    }
}
