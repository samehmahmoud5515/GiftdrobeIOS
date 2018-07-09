//
//  CartCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/28/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var item_name_txt: UILabel!
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var item_image_view: UIImageView!
    @IBOutlet weak var total_price_txt: UILabel!
    var pos: Int = -1
    var cart: Cart = Cart()
    var listner : DeleteItemFromCart?
    
    func displayContent (cart: Cart, pos: Int , listner : DeleteItemFromCart) {
        self.pos = pos
        self.cart = cart
        self.listner = listner
        item_name_txt.text = cart.name
        if let cartImg = cart.image {
            let url = URL(string: cartImg)
            let image = UIImage(named: "placeholder")
            item_image_view.kf.setImage(with: url,placeholder: image)
        }
        if let price = cart.price?.floatValue {
       // let priceInt = Int(price!)
        let price_: String? = String(describing: price)
        if let price_str: String = price_ {
            self.total_price_txt.text = price_str  + " EGP"
        }
        }
        
        let relation_tap = UITapGestureRecognizer(target: self, action: #selector(self.buttonItemFromCart))
        delete_btn.addGestureRecognizer(relation_tap)
        delete_btn.isUserInteractionEnabled = true
        if cart.type == "c" || cart.type == "w" {
            delete_btn.isHidden = true
        } else {
            delete_btn.isHidden = false
        }
    }
    
    @objc func buttonItemFromCart  () {
        listner?.deleteItemFromCart(cart: self.cart, pos: self.pos)
    }
  
    
}

protocol DeleteItemFromCart {
    func deleteItemFromCart(cart: Cart, pos: Int)
}
