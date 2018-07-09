//
//  CollectionViewHeader.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/18/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher


class CollectionViewHeader: UICollectionReusableView {
        
    @IBOutlet weak var cat_label: UILabel!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    func displayContent(inputs: [InputSource]?)
    {
        imageSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        cat_label.isHidden = false
        imageSlider.zoomEnabled = true
        if inputs != nil{
            imageSlider.isHidden = false
            imageSlider.setImageInputs(inputs!)
        }else {
            imageSlider.isHidden = true
        }
    }
}
