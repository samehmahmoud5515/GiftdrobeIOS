//
//  WrappingCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/26/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingCell: UITableViewCell {

    @IBOutlet weak var property_state_iv: UIImageView!
    @IBOutlet weak var is_required_label: UILabel!
    @IBOutlet weak var packaging_property_label: UILabel!
  
    func displayContent(wrapping_property: WrappingItem)
    {
        packaging_property_label.text = wrapping_property.name
        if wrapping_property.required == "1" && wrapping_property.selectedItem == nil {
            is_required_label.text = "Required"
            property_state_iv.isHidden = true
        }
        else if wrapping_property.selectedItem != nil
        {
            property_state_iv.isHidden = false
            property_state_iv.image = #imageLiteral(resourceName: "done_mark")
            
            self.is_required_label.text = wrapping_property.selectedItem?.name
        }
        else if wrapping_property.required == "0" && wrapping_property.selectedName == nil
        {
            is_required_label.text = "Additional"
            property_state_iv.isHidden = false
            property_state_iv.image = #imageLiteral(resourceName: "skip")
        }else if let selectedName = wrapping_property.selectedName {
            self.is_required_label.text = selectedName
            property_state_iv.image = #imageLiteral(resourceName: "done_mark")
        }
    }
  }


