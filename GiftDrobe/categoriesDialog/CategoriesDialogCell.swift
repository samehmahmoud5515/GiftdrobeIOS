//
//  CategoriesCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/29/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class CategoriesDialogCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cat_checkBox: UICheckbox!
    @IBOutlet weak var cat_label: UILabel!
    var listener : CheckBoxChecked? = nil
    var cat_: CategoriesDialogModel? = nil
    
    func displayContent(cat:CategoriesDialogModel ,listener : CheckBoxChecked)
    {
        let click_tap = UITapGestureRecognizer(target: self, action: #selector(self.checkboxClicked))
        cat_label.isUserInteractionEnabled = true
        cat_label.addGestureRecognizer(click_tap)
        cat_label.text = cat.name
        self.listener = listener
        self.cat_ = cat
      //  cat_checkBox.addGestureRecognizer(click_tap)
       // cat_checkBox.isUserInteractionEnabled = true
        cat_checkBox.onSelectStateChanged = {
          (_ checkbox: UICheckbox,  selected: Bool) -> Void in
            if selected {
                listener.onCheckboxChecked(cat: self.cat_!)
            } else {
                listener.onCheckboxUnChecked(cat: self.cat_!)
            }
        }
        
    }
    
    @objc func checkboxClicked()
    {
        if cat_checkBox.isSelected
        {
            cat_checkBox.isSelected = false
            //listener?.onCheckboxUnChecked(cat_name: self.cat_name)
        }
        else {
            cat_checkBox.isSelected = true
            //listener?.onCheckboxChecked(cat_name: self.cat_name)
        }
    }
    
 }

protocol CheckBoxChecked {
    func onCheckboxChecked(cat: CategoriesDialogModel)
    func onCheckboxUnChecked(cat: CategoriesDialogModel)

}

