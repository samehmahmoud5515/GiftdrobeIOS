//
//  CartVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/28/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
import SwiftMessages


class CartVC: BaseViewController, UITableViewDataSource , UITableViewDelegate , DeleteItemFromCart  , MoneySubmitted, SubmitCartCompeleted
{
    @IBOutlet weak var message_label: UILabel!
    var deliveryFees: String = ""
    var country = "" , city = "" , area = "" , street = ""
    var lat = "" , long = ""
    var phone = ""


    func onSubmitCartCompleted() {
        self.cartSuccessfully()
        self.eraseCart()
    }
    
    func getAllOrderAsString() -> String {
        var orders = "orders={\"orders\":[{"
        for i in 0..<self.cart_arr.count {
            let car = self.cart_arr[i]
            if car .type == "b" {
                for n in 0..<self.bouquet_arr.count {
                  let  bo = self.bouquet_arr[n]
                    if car.id == bo.id && car.generatedId == bo.generatedId {
                        if i > 0 {
                            orders += "{\"b\":\"" + car.id! + "\",\"c\":\"" }
                        else {
                            orders += "\"b\":\"" + car.id! + "\",\"c\":\""
                        }
                        orders +=   bo.card_message_id! + "\",\"c_m\":\"" + bo.message! + "\""
                        orders += ",\"s\":\"" + bo.schedule_id! + "\"}"
                        break
                    }
                }
            } else if car.type == "g" {
                if i > 0 {
                    orders += "{\"g\":\"" + car.id! + "\"" }
                else {
                    orders += "\"g\":\"" + car.id! + "\""
                }
               
                if Int(car.wrappingCount ?? "0") ?? 0 > 0{
                    orders += ",\"w\":[" }
                var w_count = 0
                for j in 0..<self.wrapping_arr.count {
                    let wr = self.wrapping_arr[j]
                    if  car.id == wr.giftId && car.generatedId == wr.generatedGiftId{
                        orders += "\"" + wr.id! + "\""
                        if w_count != Int(car.wrappingCount!)! - 1 {
                            orders += ","
                        }
                        w_count = w_count + 1
                    }
                }
                if Int(car.wrappingCount ?? "0") ?? 0 > 0 {
                    orders += "]" }
                orders += "}"
            } else if car.type == "cb" {
                if i > 0 {
                    orders += "{\"f\":[" }
                else {
                    orders += "\"f\":["
                }
                
                var count = 0
                let bCount = Int(car.wrappingCount ?? "1") ?? 1
                var message_index = -1
                for k in 0..<self.flowers_arr.count {
                    let fl = self.flowers_arr[k]
                    if fl.bouquetId == car.id  {
                        message_index = k
                        orders += "{\"fid\":\""
                        orders +=  fl.id! + "\",\"number\":\"" + fl.quantity! + "\",\"color\":\""
                        orders += fl.color_id! + "\""
                        orders += "}"
                        if count != bCount - 1 {
                            orders += ","
                        }
                        count = count + 1
                    }
                }
                orders += "]"
                if message_index != -1 {
                    let f_ = self.flowers_arr[message_index]
                    if f_.bouquetId == car.id {
                        orders += ",\"c\":\"" + f_.card_message_id! + "\",\"c_m\":\"" + f_.message! + "\""
                        orders += ",\"s\":\"" + f_.schedule_id! + "\"}"

                    }
                }
            }
            if (i != self.cart_arr.count - 1) && (self.cart_arr[i+1].type == "g" || self.cart_arr[i+1].type == "b" || self.cart_arr[i+1].type == "cb")  {
                orders += ","
            }
        }
        orders += "]}"
        return orders
    }
    //"&GiftMessageOrder:{\"GiftMessageOrder\":[{\"g\":\"1\",\"c\":\"1\",\"m\":\"hii\"}]}"
    func getGiftCard() -> String {
        var giftCardStr = ""
        if giftsCard_arr.count > 0 {
            giftCardStr += "&GiftMessageOrder={\"GiftMessageOrder\":["
        }
        for i in 0..<self.cart_arr.count {
                let car = self.cart_arr[i]
                if car.type == "g" {
                    for j in 0..<giftsCard_arr.count {
                        let gc = giftsCard_arr[j]
                        if gc.giftGeneratedId == car.generatedId && gc.giftId == car.id {
                            giftCardStr += "{\"g\":\"" + car.id! + "\",\"c\":\""
                            giftCardStr +=  gc.id! + "\",\"m\":\"" + gc.message! + "\"}"
                            if j + 1 < giftsCard_arr.count {
                                giftCardStr += ","
                            }
                        }
                    }
                }
        }
        if giftCardStr != "" {
            giftCardStr += "]}"
        }
        return giftCardStr
    }
    
    func onMoneySubmitted() {
         self.startActivityIndicator()
        let userManagemnet = UserDataManager()
        self.api.submitCart(userId:userManagemnet.getUserId() ,  city: city ,country: country ,area: area ,address: area , paid: "1" ,lat: lat, lng: long, phone: phone,orders:  self.getAllOrderAsString() ,giftCard: self.getGiftCard(),
                            completion : {_ in
                                self.stopActivityIndicator()
                                self.cartSuccessfully()
                                self.eraseCart()
        })
    }
    
    func deleteItemFromCart(cart: Cart, pos: Int) {

        for wrap in wrapping_arr {
            if cart.id == wrap.id  && cart.type == "w" {
                 PersistanceService.context.delete(wrap as NSManagedObject)
                 break
            }
        }

        // when deleteing gift delete wrapping
        let cartType = cart.type ?? ""
        let cartId = cart.id ?? ""
        let cartGenId = cart.generatedId ?? ""
        if cartType == "g" {
            let wrappinCount = Int (cart.wrappingCount ?? "1") ?? 1
            var count = 0
            var count_ = 0
            for w in wrapping_arr {
                
                let w_id = w.giftId
                let wrapId = w.id
                if w_id == cartId && cartGenId == w.generatedGiftId {
                    PersistanceService.context.delete(w as NSManagedObject)
                    for c in cart_arr {
                        if wrapId == c.id && c.type == "w" {
                            PersistanceService.context.delete(c as NSManagedObject)
                            count_ = count_ + 1
                            if count_ == wrappinCount {
                                break
                            }
                        }
                    }
                    count = count + 1
                    if count == wrappinCount {
                        break
                    }
                }
            }
            for cc in cart_arr {
                if cc.type == "c" && cc.generatedId == cartGenId {
                    PersistanceService.context.delete(cc as NSManagedObject)
                    break
                }
            }
            for gc in giftsCard_arr {
                if gc.giftGeneratedId == cartGenId && gc.giftId == cartId {
                    PersistanceService.context.delete(gc as NSManagedObject)
                    break
                }
            }
            
        }
        // delete card when delete custom bouquet
        if cartType == "cb" {
            var m_card = ""
            for f in flowers_arr {
                if f.bouquetId == cartId {
                    m_card = f.card_message_id!
                    PersistanceService.context.delete(f as NSManagedObject)
                }
            }
            for cc in cart_arr {
                if cc.type == "c" && cc.id == m_card {
                    PersistanceService.context.delete(cc as NSManagedObject)
                    break
                }
            }
        }
        // delete card when delete bouquetas
        if cartType == "b" {
            var m_card = ""
            for b in bouquet_arr {
                if cartId == b.id && b.generatedId == cartGenId{
                    m_card = b.card_message_id!
                    PersistanceService.context.delete(b as NSManagedObject)
                    break
                }
            }
            for cc in cart_arr {
                if cc.type == "c" && cc.id == m_card {
                    PersistanceService.context.delete(cc as NSManagedObject)
                    break
                }
            }
        }
        
        PersistanceService.context.delete(cart as NSManagedObject)
        cart_arr.remove(at: pos)
        PersistanceService.saveContext()
        
        
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        do {
            cart_arr = try PersistanceService.context.fetch(fetchRequest)
        }catch {
            print("error : \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if cart_arr.count == 0 {
            hideViews()
            self.tableView.backgroundView = self.errorView
            self.message_label.text = "Cart is Empty, continue shopping"
        }
      _ =  calculateTotalPrice ()
    }
    

    @IBOutlet weak var payment_btn: UIButton!
    @IBOutlet weak var total_price_label: UILabel!
    @IBOutlet weak var total_price_val_label: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var api : CartAPI!

    var cart_arr = [Cart]()
    var wrapping_arr = [Wrappings]()
    var bouquet_arr = [Bouquet]()
    var flowers_arr = [Flowers]()
    var giftsCard_arr = [GiftsCard]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        
        cell.displayContent(cart: cart_arr[indexPath.row], pos: indexPath.row , listner: self)
      
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 153
    }
    
    
    var apple_payment: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.getCart()
       
       
    }

  
    @IBAction func payment_btn_action(_ sender: Any) {
        print(self.getGiftCard())
        self.startActivityIndicator()
        api.getDeliveryFees(compeletion: {
            json in
            if json != nil && json!.success == 1 {
                self.apple_payment = (json?.apple_payment)!
                DispatchQueue.main.async {
                    // self.deliveryFees_label.text = "+ delivery fees: " + (json?.fees)! + "EGP"
                    self.deliveryFees = json?.fees ?? "60"
                    self.stopActivityIndicator()
                    if self.deliveryFees != "" {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentDesginSB", bundle: nil)
                        let navigationCont = storyBoard.instantiateViewController(withIdentifier: "PaymentSteps") as! UINavigationController
                        if let  tabCont = navigationCont.topViewController as? UITabBarController {
                            let controllers = tabCont.viewControllers
                            if controllers!.count > 0 {
                                if let shipp = controllers![1] as? ShippingVC {
                                    shipp.total_price = String (self.calculateTotalPrice())
                                    shipp.deliveryFees = self.deliveryFees
                                    
                                }
                                if let add = controllers![0] as? GetAddressVC {
                                    add.total_price = String (self.calculateTotalPrice())
                                }
                                if let pay = controllers![2] as? PaymentMethodVC {
                                    pay.deliveryFees = self.deliveryFees
                                    pay.total_price = String (self.calculateTotalPrice())
                                    pay.orderStr = self.getAllOrderAsString()
                                    pay.giftCardStr = self.getGiftCard()
                                    pay.isOpened = self.apple_payment
                                    pay.submitComp = self
                                }
                            }
                        }
                        
                        self.present(navigationCont, animated: true, completion: nil)
                    } else {
                        self.failed()
                    }
                }
            }
        })
        
       
    }
    
    func hideViews() {
        DispatchQueue.main.async {
        self.payment_btn.isHidden = true
        self.total_price_label.isHidden = true
         self.total_price_val_label.isHidden = true
         //self.deliveryFees_label.isHidden = true
        }
    }
    func showViews() {
        DispatchQueue.main.async {
        self.payment_btn.isHidden = false
        self.total_price_label.isHidden = false
        self.total_price_val_label.isHidden = false
        //self.deliveryFees_label.isHidden = true
        }
    }
    
    func calculateTotalPrice () -> Float {
        var t_price: Float = 0
        for c in cart_arr {
            if  c.type == "f" {
                for flower in flowers_arr {
                    if c.id == flower.id {
                        if let quan:Float = Float(flower.quantity ?? "1") {
                            t_price += Float(c.price!)! * quan
                            break
                        }
                    }
                }
            } else {
                t_price += Float(c.price!)!
            }
        }
         DispatchQueue.main.async {
            self.total_price_val_label.text = String (t_price) + " EGP"
        }
        return t_price
    }
    
    
  @IBAction func home_action(_ sender: Any) {
    DispatchQueue.main.async {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = RootViewControoler()
        let aObjNavi = UINavigationController(rootViewController: mainViewController)
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let slideMenuController = SlideMenuController(mainViewController: aObjNavi, leftMenuViewController: leftViewController)
        self.present(slideMenuController, animated: false, completion: nil)
     }
    }
    
    func cartSuccessfully(){
        DispatchQueue.main.async {
            self.message_label.text = "Order submitted sucessfully, Thanks for using Giftdrobe"
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✔"
            view.configureContent(title: "Done", body: "Oreder submitted sucessfully", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    func failed(msg: String = "Something wrong, please try again later")
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    func eraseCart()  {
 
        let car_delete_req = NSBatchDeleteRequest(fetchRequest: Cart.fetchRequest())
        do {
            try PersistanceService.context.execute(car_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let w_delete_req = NSBatchDeleteRequest(fetchRequest: Wrappings.fetchRequest())
        do {
            try PersistanceService.context.execute(w_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let b_delete_req = NSBatchDeleteRequest(fetchRequest: Bouquet.fetchRequest())
        do {
            try PersistanceService.context.execute(b_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let f_delete_req = NSBatchDeleteRequest(fetchRequest: Flowers.fetchRequest())
        do {
            try PersistanceService.context.execute(f_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let userMana = UserDataManager()
        userMana.saveScheduleId(scheduleId_:"0")
        getCart()
    }
    func getCart () {
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        let fetchRequest1 : NSFetchRequest<Wrappings> = Wrappings.fetchRequest()
        let fetchRequest2 : NSFetchRequest<Bouquet> = Bouquet.fetchRequest()
        let fetchRequest3 : NSFetchRequest<Flowers> = Flowers.fetchRequest()
        let fetchRequest4 : NSFetchRequest<GiftsCard> = GiftsCard.fetchRequest()
        
        do {
            cart_arr = try PersistanceService.context.fetch(fetchRequest)
            if cart_arr.count == 0 {
                DispatchQueue.main.async {
                    self.tableView.backgroundView = self.errorView
                    self.hideViews() }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print("error : \(error)")
        }
        
        do {
            wrapping_arr = try PersistanceService.context.fetch(fetchRequest1)
        }catch {
            print("error : \(error)")
        }
        
        do {
            bouquet_arr = try PersistanceService.context.fetch(fetchRequest2)
        }catch {
            print("error : \(error)")
        }
        
        do {
            flowers_arr = try PersistanceService.context.fetch(fetchRequest3)
        }catch {
            print("error : \(error)")
        }
        do {
            giftsCard_arr = try PersistanceService.context.fetch(fetchRequest4)
        }catch {
             print("error : \(error)")
        }
        _ = calculateTotalPrice ()
    }
}


