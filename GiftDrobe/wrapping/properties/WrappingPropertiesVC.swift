//
//  WrappingPropertiesVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages


class WrappingPropertiesVC: BaseViewController , UITableViewDelegate , UITableViewDataSource
, OnItemSelected , CardSelected{
   
    func onItemSelected(position: Int, wrappingSelection: WrappingSelection) {
        viewModel.replaceItemInList(position: position , selected: wrappingSelection, completion: {
            let gift_price = gift?.price ?? "0"
            let gift_price_ = (gift_price as NSString).floatValue
            let totalPrice: Float = viewModel.getWrappingsPrice() + gift_price_
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.total_price_val_label.text = String (totalPrice) + " EGP"
            }
        })
    }
    
     func onCardSelected(message: String, card: CardModel) {
        self.giftMessage = message
        self.giftCard = card
        
        let gift_price = gift?.price ?? "0"
        let gift_price_ = (gift_price as NSString).floatValue
        let card_price = (card.price ?? "0").floatValue
        let totalPrice: Float = viewModel.getWrappingsPrice() + gift_price_ + card_price
        self.viewModel.replaceFirstCardItem (cardName: card.name!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.total_price_val_label.text = String (totalPrice) + " EGP"
        }
     }
    
    var selectedtPosition = 0
    @IBOutlet var viewModel : WrappingViewModel!
    var addGift_bool: Bool = true
    var wrapping_added: Bool = true
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var total_price_val_label: UILabel!
    @IBOutlet weak var total_price_label: UILabel!
    var gift : Gift!
    var listener: GoToCart?
    var backListener : BackToProductDetails?
    var giftMessage: String = ""
    var giftCard: CardModel?
    var ramdomStr : String = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ramdomStr = random()
       initilizeList()
       // submit_btn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
       if  let price = gift.price {
        self.total_price_val_label.text = price + " EGP"
        }
        self.submit_btn.setTitle("Add to cart", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "packingCell", for: indexPath) as! WrappingCell
        cell.displayContent(wrapping_property: viewModel.getWrappingItem(indexPath: indexPath))
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.submit_btn.isHidden = false
       
        if self.viewModel.getWrappingItem(indexPath: indexPath).name == "Cards" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CardVC_nav") as! UINavigationController
            if let chidVC = newViewController.topViewController as? CardVC {
                chidVC.listener = self
                selectedtPosition = indexPath.row
            }
            self.present(newViewController, animated: true, completion: nil)
        }else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "WrappingSB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "WrappingItemsSelectionVC_nav") as! UINavigationController
            if let chidVC = newViewController.topViewController as? WrappingItemsSelectionVC {
                chidVC.listener = self
                chidVC.parent_id = viewModel.getWrappingId(indexPath: indexPath)
                chidVC.parent_position = indexPath.row
                chidVC.parent_name = viewModel.getWrappingItem(indexPath: indexPath).name ?? ""
                chidVC.gift_id = self.gift.id!
            }
            
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
 
    func initilizeList ()
    {
        self.startActivityIndicator()
        viewModel.requestWrappings(cat_id:self.gift.category_id ?? "0" ,compeletion: {
            success in
            if success == true {
                 DispatchQueue.main.async {
                     self.tableView.backgroundView = nil
                     self.tableView.reloadData()
                   
                }
            }else {
                 DispatchQueue.main.async {
                    self.submit_btn.isHidden = false
                    self.tableView.backgroundView = self.errorView
                }
            }
            self.stopActivityIndicator()
        })
    }
    
    func addGiftAction(){
      
        DispatchQueue.main.async {
            self.addedSuccessfully()
            self.dismiss(animated: true, completion: nil)
            self.backListener?.onBackToProductDetails()
        }
    }
    

    @IBAction func submit_btn_action(_ sender: Any) {

        self.saveGift()
        self.saveWrappings()
        self.saveGiftCard()
    }
    
    
    @IBAction func wrapping_back_btn_action(_ sender: Any) {
       saveWrappings()
       self.performSegueToReturnBack()
    }
    
    func saveGift () {
        if (addGift_bool){
            let cart = Cart (context:PersistanceService.context)
            cart.id = gift.id
            cart.generatedId = ramdomStr
            cart.image = gift.images?[0]
            cart.name = gift.name
            cart.price = gift.price
            cart.type = "g"
            cart.wrappingCount = String(self.viewModel.getSelectedItemsCount())
            print (self.viewModel.getSelectedItemsCount())
            PersistanceService.saveContext()
            addGift_bool = false
        }
    }
    
    func saveGiftCard() {
        if giftMessage == "" {
            return
        }
        if let card = giftCard {
            let giftCard = GiftsCard (context:PersistanceService.context)
            giftCard.id = card.id
            giftCard.message = self.giftMessage
            giftCard.giftId = self.gift.id
            giftCard.giftGeneratedId = ramdomStr
            PersistanceService.saveContext()
            
            let cart1 = Cart (context:PersistanceService.context)
            cart1.id = card.id
            cart1.image = card.image
            cart1.name = "Message card"
            cart1.price = card.price
            cart1.type = "c"
            cart1.generatedId = ramdomStr
            PersistanceService.saveContext()
        }
    }
    
    func saveWrappings() {
        if (!addGift_bool && wrapping_added == true){
            self.wrapping_added = false
            var selectedItems : [WrappingSelection] = []
            selectedItems = self.viewModel.getSelectedItem()
            for wrappingSelection in selectedItems {
                let wra = Wrappings (context:PersistanceService.context)
                wra.id = wrappingSelection.id
                wra.image = wrappingSelection.image
                wra.name = wrappingSelection.name
                wra.price = wrappingSelection.price
                wra.giftId = gift.id
                wra.generatedGiftId = ramdomStr
                PersistanceService.saveContext()
                
                let cart = Cart (context:PersistanceService.context)
                cart.id = wrappingSelection.id
                cart.image = wrappingSelection.image
                cart.name = wrappingSelection.name
                cart.price = wrappingSelection.price
                cart.type = "w"
                PersistanceService.saveContext()
            }
            addGiftAction()
        }
     }
    func random(length: Int = 5) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func addedSuccessfully(){
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✔"
            view.configureContent(title: "Sucessfull", body: "Gift added Successfully to shopping cart", iconText: iconText)
            SwiftMessages.show(view: view)
         
        }
    }
  }



extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

protocol BackToProductDetails {
   func onBackToProductDetails()
}

protocol GoToCart {
    func goToCart()
}
