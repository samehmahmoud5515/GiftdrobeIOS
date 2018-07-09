//
//  GenderVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/16/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class GenderVC: UIViewController {

    @IBOutlet weak var sendFlower: UIImageView!
    
    @IBOutlet weak var sendGift: UIImageView!
    var selectedType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sendGift_tap = UITapGestureRecognizer(target: self, action: #selector(self.navigateToFiler))
        sendGift.isUserInteractionEnabled = true
        sendGift.addGestureRecognizer(sendGift_tap)
        
        let sendFlower_tap = UITapGestureRecognizer(target: self, action: #selector(self.navigateToFlowers))
        sendFlower.isUserInteractionEnabled = true
        sendFlower.addGestureRecognizer(sendFlower_tap)
        
        
        
    }

 
    
  
    @objc   func navigateToFiler()
    {
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstFilterVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func navigateToFlowers() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Once_or_Scheduled_VC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}
