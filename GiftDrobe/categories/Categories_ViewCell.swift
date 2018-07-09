//
//  Categories_ViewCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Kingfisher


class Categories_ViewCell: UICollectionViewCell {
    

    @IBOutlet weak var cat_image_iv: UIImageView!
    @IBOutlet weak var cat_name_label: UILabel!
    @IBOutlet weak var cat_view_bg: UIView!
    
    func displayContent (category: CategoriesModel)
    {
        cat_name_label.text = category.name
        cat_view_bg.roundCorners([.bottomRight, .bottomLeft], radius: 12)
        if let catImage = category.icon  {
            let url = URL(string: catImage)
            let image = UIImage(named: "placeholder")
            cat_image_iv.kf.setImage(with: url,placeholder: image)
        }
    }
    
}



