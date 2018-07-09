//
//  FlowerContainerVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import BmoViewPager

private let mainColor = UIColor(hexString: "#DD3334")

class FlowerContainerVC: BaseViewController {

    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var ViewPagerNavigationBar: BmoViewPagerNavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        ViewPagerNavigationBar.autoFocus = true
        ViewPagerNavigationBar.viewPager = viewPager

        
        viewPager.layer.borderWidth = 1.0
        viewPager.layer.cornerRadius = 5.0
        viewPager.layer.masksToBounds = true
        viewPager.layer.borderColor = UIColor.white.cgColor
       
    }

   

}

protocol Update {
    func updateTitle(id: String)
}

extension FlowerContainerVC: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
        return [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22.0),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "#545454")
            ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
        return [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22.0),
            NSAttributedStringKey.foregroundColor : mainColor,
           
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UnderLineView()
        view.marginX = 8.0
        view.lineWidth = 8.0
        view.strokeColor = mainColor
        return view
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        switch page {
        case 0:
            return "Bouquets"
        case 1:
            return "Customize"
        
        default:
            return  ""
        }
        
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        var controller:UIViewController!
        
        if page == 0{
            controller = storyboard.instantiateViewController(withIdentifier: "BouquetVC")
        }
        else if page == 1 {
            controller = storyboard.instantiateViewController(withIdentifier: "CustomizeFlowersVC")
            
        }
        return controller
    }
}
