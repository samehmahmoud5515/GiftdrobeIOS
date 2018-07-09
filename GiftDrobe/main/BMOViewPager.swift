//
//  BMOViewPager.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/21/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import BMOViewPager
class BMOViewPager: BmoViewPager ,BmoViewPagerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return 2
    }
    

}
