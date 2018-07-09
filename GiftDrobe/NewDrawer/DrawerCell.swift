//
//  DrawerCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/27/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {

    
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var cellViewCont: UIView!
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    var listner :OnDrawerMenuClicked!
    var position: Int!
    func displayContent(position: Int,calenderCount: Int,listner_ :OnDrawerMenuClicked)
    {
        self.listner = listner_
        let click_tap = UITapGestureRecognizer(target: self, action: #selector(self.openCategories))

        circularView.isHidden = true
        badgeLabel.isHidden = true
        if position == 0
        {
            menuTitle.text = "MyProfile"
            menuImage.image = #imageLiteral(resourceName: "profileee")
         
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 18)
             menuTitle.textColor = UIColor.white
        }
        else if position == 1
        {
            menuTitle.text = "MyCalender"
            menuImage.image = #imageLiteral(resourceName: "calendar128")
            
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 18)
             menuTitle.textColor = UIColor.white
            
            if calenderCount > 0 {
                circularView.isHidden = false
                badgeLabel.isHidden = false
                badgeLabel.text = String(calenderCount)
                circularView.layer.borderWidth = 1.0
                circularView.layer.masksToBounds = false
                circularView.layer.borderColor = UIColor.white.cgColor
                circularView.layer.cornerRadius = circularView.frame.size.width / 2
                circularView.clipsToBounds = true
            }
        }
            
        
        else if position == 2
        {
            menuTitle.text = "Categories"
            menuImage.image = #imageLiteral(resourceName: "category")
            menuTitle.isUserInteractionEnabled = true
            menuImage.isUserInteractionEnabled = true

            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 18)
             menuTitle.textColor = UIColor.white
        }
    
        else if position == 4 {
            menuTitle.text = "Suggesstion"
            menuImage.image = #imageLiteral(resourceName: "suggesstion32")
            menuTitle.isUserInteractionEnabled = true
            menuImage.isUserInteractionEnabled = true
            
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 18)
            menuTitle.textColor = UIColor.white
        }
       
        else if position == 5
        {
            menuTitle.text = "Premium"
            menuImage.image = #imageLiteral(resourceName: "primium_ic")
            menuTitle.isUserInteractionEnabled = true
            menuImage.isUserInteractionEnabled = true
            
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Lovelo", size: 21)
            menuTitle.textColor = UIColor.black
        }
            
        else if position == 6
        {
            menuTitle.text = "Send Flowers"
            menuImage.image = #imageLiteral(resourceName: "flower")
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.font = UIFont(name: "Majestic", size: 21)
            menuTitle.textColor = UIColor.white
        }
            
        else if position == 8
        {
            menuTitle.text = "Invite Friends"
            menuImage.image = #imageLiteral(resourceName: "invite")
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
            menuTitle.textColor = UIColor.white
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 15)
        }
            
        else if position == 9
        {
            menuTitle.text = "Sign out"
            menuImage.image = #imageLiteral(resourceName: "signout")
            menuTitle.textColor = UIColor.white
            menuTitle.font = UIFont(name: "Montserrat-Bold", size: 15)
            menuTitle.addGestureRecognizer(click_tap)
            menuImage.addGestureRecognizer(click_tap)
            cellViewCont.addGestureRecognizer(click_tap)
            self.position = position
        }
        
        if position == 3 || position == 7
        {
            menuTitle.isHidden = true
            menuImage.isHidden = true
        }else {
            menuTitle.isHidden = false
            menuImage.isHidden = false
        }
       
        
    
       
    }
    
    @objc func openCategories()
    {
       self.listner.onDrawerMenuClicked(position: self.position)
    }
    
   
    
}

protocol OnDrawerMenuClicked {
    func onDrawerMenuClicked (position: Int)
}
