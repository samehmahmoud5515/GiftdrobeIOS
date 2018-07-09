//
//  DemoViewController2.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager
import CoreData

class MainViewController: UIViewController {
 
    
    @IBAction func openDrawer(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    var cart_arr = [Cart]()
    @IBOutlet weak var cart_btn : BadgeBarButtonItem!
    @IBOutlet weak var viewPagerSegmentedView: SegmentedView!
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   viewPagerNavigationBar.tintColor = UIColor(hexString: "#dd5333")
        
        viewPagerNavigationBar.viewPager = viewPager
        viewPagerNavigationBar.layer.masksToBounds = true
        viewPagerNavigationBar.layer.cornerRadius = viewPagerSegmentedView.layer.cornerRadius
        viewPager.presentedPageIndex = 0
        viewPager.infinitScroll = true
        viewPager.dataSource = self
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        do {
            cart_arr = try PersistanceService.context.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                self.cart_btn.badgeNumber = self.cart_arr.count
            }
            
        } catch {
            print("error : \(error)")
        }
    }
  
    
    @IBAction func filer_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstFilterVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}

extension MainViewController: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
        return [
            NSAttributedStringKey.foregroundColor : UIColor.white//viewPagerSegmentedView.strokeColor
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
        return [
            NSAttributedStringKey.foregroundColor : UIColor.init(hexString: "#b02829")
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        
        switch page {
        case 0:
            return "Home"
        case 1:
            return "Recent"
        case 2:
            return "Trending"
        case 3:
            return "Offers"
        default:
            return  ""
        }
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(width: navigationBar.bounds.width / 4, height: navigationBar.bounds.height)
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = viewPagerSegmentedView.strokeColor
        return view
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controller:UIViewController!
        if page == 0{
             controller = storyboard.instantiateViewController(withIdentifier: "cat_vc")
            
        }
        else if page == 1 {
             controller = storyboard.instantiateViewController(withIdentifier: "recent_vc")

        }
        else if page == 2 {
            controller = storyboard.instantiateViewController(withIdentifier: "TrendingVC")
            
        }
        else  {
            controller = storyboard.instantiateViewController(withIdentifier: "OffersVC")
            
        }
 
        return controller
    }
    
    
    
}

