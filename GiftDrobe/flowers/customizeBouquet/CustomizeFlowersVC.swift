//
//  CustomizeFlowersVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages

class CustomizeFlowersVC: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate
,UICollectionViewDelegateFlowLayout ,SetSelectedFlower  ,CardSelected {
    
    
    
    var scheduleId = ""

    func onCardSelected(message: String, card: CardModel) {
        
        
            for singleFlower in flowers_arr {
            
            let flower = Flowers (context:PersistanceService.context)
            flower.id = singleFlower.id
            flower.quantity = "\(singleFlower.quantity ?? 1)"
            let userMana = UserDataManager()
            let scheduleId_ = userMana.getScheduleId()
            flower.schedule_id = scheduleId_
            flower.color_id = singleFlower.color![singleFlower.selectedColor!].id
            flower.message = message
            flower.card_message_id = card.id
            flower.bouquetId = rondomStr
            PersistanceService.saveContext()
            
                // remove schdule Id
                userMana.saveScheduleId(scheduleId_:"0")
        }
        
        
        
        let cart = Cart (context:PersistanceService.context)
        cart.id = rondomStr
        cart.image = ""
        cart.name = "Custom bouquet "
        var t_price:Float = 0.0
        var flowers_num = 0
        for f in self.flowers_arr {
            let qun = Float (f.quantity ?? Int(1.0))
            let quan_ = f.quantity ?? 1
            let p :Float = f.price!.floatValue
            t_price += (p * qun)
            flowers_num += quan_
        }
        cart.name = "Custom bouquet: " + String(flowers_num) + " flowers"
        cart.price = String(t_price)
        cart.type = "cb"
        cart.wrappingCount = String(flowers_arr.count)
        PersistanceService.saveContext()
        
        let cart1 = Cart (context:PersistanceService.context)
        cart1.id = card.id
        cart1.image = card.image
        cart1.name = "Message card"
        cart1.price = card.price
        cart1.type = "c"
        PersistanceService.saveContext()
            
        self.bouquetAddedSuccessfully()
            
        
    }
    
    var flowers_arr : [SingleFlower] = []
    func setSelectedFlower(singleFlower: SingleFlower) {
        var duplicate : Bool = false
        for i in 0..<flowers_arr.count  {
            if flowers_arr[i].id == singleFlower.id && flowers_arr[i].selectedColor == singleFlower.selectedColor {
                flowers_arr[i].quantity = flowers_arr[i].quantity! + singleFlower.quantity!
                duplicate = true
                break
            }
        }
        if duplicate == false {
            flowers_arr.append(singleFlower)
        }
         DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.payment_btn.isHidden = false
        }
    }
    
  
    @IBOutlet weak var add_flowers_cont: UIView!
    
    @IBOutlet weak var payment_btn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var rondomStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let click_tap = UITapGestureRecognizer(target: self, action: #selector(self.selectFlowers))
        add_flowers_cont.isUserInteractionEnabled = true
        add_flowers_cont.addGestureRecognizer(click_tap)
        payment_btn.isHidden = true

        rondomStr = random()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flowers_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomFlowersCell", for: indexPath) as! CustomFlowersCell
        cell.displayContent(flower: flowers_arr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 5
        let cellSpacing : CGFloat = 5
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
        
    }
    
   @IBAction func add_flowers_btn_action(_ sender: Any) {
        selectFlowers()
    }

    @objc func selectFlowers()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SelectFlowerCustomizeVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? SelectFlowerCustomizeVC {
            chidVC.customFlowerAddProtocol = self
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func payment_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CardVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? CardVC {
            chidVC.listener = self
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func bouquetAddedSuccessfully(){
        
        DispatchQueue.main.async {
            
            self.addedSuccessfully()
            self.flowers_arr = []
            self.collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)

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
            view.configureContent(title: "Sucessfull", body: "Bouquet added Successfully to shopping cart", iconText: iconText)
            SwiftMessages.show(view: view)
            
        }
    }
    
}
extension CustomizeFlowersVC: Update {
    func updateTitle(id: String) {
        scheduleId = id
        print("id ",id)
    }
}
