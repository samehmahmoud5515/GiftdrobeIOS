//
//  PaymentContVc.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class PaymentContVc: UITabBarController {

    @IBOutlet weak var tab_bar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.parent?.view.backgroundColor = .white
        self.view.backgroundColor = .white
        tab_bar.invalidateIntrinsicContentSize()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 50
        tabFrame.origin.y = 0
        tab_bar.frame = tabFrame
    }
}
