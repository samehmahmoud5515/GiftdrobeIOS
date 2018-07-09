//
//  Once_or_Scheduled_VC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class Once_or_Scheduled_VC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func scheduled_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SchedulingListVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func once_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FlowerContainerVC_nav") 
        self.present(newViewController, animated: true, completion: nil)
    }
}
