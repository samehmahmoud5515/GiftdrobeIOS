//
//  CheckBox.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/21/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
protocol RadioBtnDelgate {
    func onRadioBtnClicked(isChecked:Bool,name: String)

}

class RadioButton_: UIButton {
    var delegate: RadioBtnDelgate?
    var name = ""
    // Images
    let checkedImage = UIImage(named: "selected24")! as UIImage
    let uncheckedImage = UIImage(named: "unselected24")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
                delegate?.onRadioBtnClicked(isChecked:true,name: name)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
                delegate?.onRadioBtnClicked(isChecked:false,name: name)
            }
        }
    }
    
    override func awakeFromNib() {
        //self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
     @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
