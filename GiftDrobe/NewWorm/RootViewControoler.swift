//
//  RootViewControoler.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/5/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import PagingMenuController
import CoreData

private struct PagingMenuOptions: PagingMenuControllerCustomizable {

    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController1 = storyBoard.instantiateViewController(withIdentifier: "cat_vc")
        let viewController2 = storyBoard.instantiateViewController(withIdentifier: "recent_vc")
        let viewController3 = storyBoard.instantiateViewController(withIdentifier: "TrendingVC")
        let viewController4 = storyBoard.instantiateViewController(withIdentifier: "OffersVC")


        return [viewController1, viewController2,viewController3,viewController4]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: MenuItemWidthMode.flexible, centerItem: false, scrollingMode: MenuScrollingMode.scrollEnabledAndBouces)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2() , MenuItem3() , MenuItem4()]
        }
        var focusMode: MenuFocusMode {
            return .roundRect(radius: CGFloat(8), horizontalPadding: CGFloat(1), verticalPadding: CGFloat(4), selectedColor: UIColor(hexString: "#b02829"))
        }
    }
   /* fileprivate var focusMode: MenuFocusMode {
        return .roundRect(radius: CGFloat(20), horizontalPadding: CGFloat(16), verticalPadding: CGFloat(16), selectedColor: UIColor.red)
    }*/
   
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Home"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Recent"))
        }
    }
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Trending"))
        }
    }
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Offers"))
        }
    }
}

class RootViewControoler: UIViewController {

   
    var cart_button : UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#dd3334")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "EdwardianScriptITC", size: 30)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.title = "Giftdrobe"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(hexString: "#dd3334")
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
        let filter_btn =  UIBarButtonItem(image: #imageLiteral(resourceName: "filer_ic"), style: .plain, target: self, action: #selector(navigate_to_filter))
         cart_button = UIBarButtonItem(image: #imageLiteral(resourceName: "shop"), style: .plain, target: self, action: #selector(openCart))
        
        let noti_button = UIBarButtonItem(image: #imageLiteral(resourceName: "noti"), style: .plain, target: self, action: #selector(openNotification))
        let drawer_button = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-2"), style: .plain, target: self, action: #selector(openDrawer))
        
        navigationItem.rightBarButtonItems = [cart_button! ,filter_btn]
        navigationItem.leftBarButtonItems = [drawer_button , noti_button ]


        view.backgroundColor = UIColor.white
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        //pagingMenuController.view.frame.origin.y += 88
        //pagingMenuController.view.frame.size.height -= 88
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        do {
            var cart_arr = [Cart]()
            cart_arr = try PersistanceService.context.fetch(fetchRequest)
            DispatchQueue.main.async {
                if cart_arr.count > 0 {
                    self.cart_button?.addBadge(number: cart_arr.count)
                }else {
                     self.cart_button?.removeBadge()
                }
            }
        } catch {
            print("error : \(error)")
        }
    }
    
   @objc func navigate_to_filter() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstFilterVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
     @objc func openDrawer() {
        self.slideMenuController()?.openLeft()
    }
    @objc func openNotification() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
   @objc func openCart() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CartVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
}

