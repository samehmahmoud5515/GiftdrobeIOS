//
//  BaseViewController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/15/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData

class BaseViewController: UIViewController , NVActivityIndicatorViewable {

    @IBOutlet weak var cart_btn_base : BadgeBarButtonItem?
    var cart_array = [Cart]()

    func startActivityIndicator(){
        DispatchQueue.main.async {
             self.startAnimating (CGSize(width: 50, height: 50), color : UIColor(hexString: "#dd3334"))
          
            }
    }
    
    func stopActivityIndicator()
    {
        DispatchQueue.main.async {
            self.stopAnimating()
           }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        do {
            cart_array = try PersistanceService.context.fetch(fetchRequest)
            DispatchQueue.main.async {
                
               self.cart_btn_base?.badgeNumber = self.cart_array.count
                
            }
            
        } catch {
            print("error : \(error)")
        }
    }
}
