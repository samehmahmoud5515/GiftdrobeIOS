//
//  BouquetVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages


class BouquetVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,CardSelected {
    
    var selectedtPosition = 0
    
    var bouquetAdded = false
    @IBOutlet weak var bottom_spinner :UIActivityIndicatorView!

    var page : Int = 1
    var limit : Int = 14
    var loadMore =  true

  
    func random(length: Int = 5) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func onCardSelected(message: String, card: CardModel) {
      if bouquetAdded == false {
        let gene_id = random()
        let bouquet = Bouquet (context:PersistanceService.context)
        bouquet.id = viewModel.getBouquetId(indexPath: selectedtPosition)
        bouquet.image = viewModel.getBouquet(indexPath: selectedtPosition).image
        bouquet.name = viewModel.getBouquet(indexPath: selectedtPosition).name
        bouquet.price = viewModel.getBouquet(indexPath: selectedtPosition).price
        bouquet.message = message
        bouquet.card_message_id = card.id
        let userMana = UserDataManager()
        let scheduleId_ = userMana.getScheduleId()
        bouquet.schedule_id = scheduleId_
        bouquet.generatedId = gene_id
        PersistanceService.saveContext()
        
        // remove schdule Id 
        userMana.saveScheduleId(scheduleId_:"0")
        
        let cart = Cart (context:PersistanceService.context)
        cart.id = viewModel.getBouquetId(indexPath: selectedtPosition)
        cart.image = viewModel.getBouquet(indexPath: selectedtPosition).image
        cart.name = "Bouquet: " + viewModel.getBouquet(indexPath: selectedtPosition).name!
        cart.price = viewModel.getBouquet(indexPath: selectedtPosition).price
        cart.type = "b"
        cart.generatedId = gene_id
        PersistanceService.saveContext()
        self.bouquetAddedSuccessfully()
        self.bouquetAdded = true
        
        let cart1 = Cart (context:PersistanceService.context)
        cart1.id = card.id
        cart1.image = card.image
        cart1.name = "Message card"
        cart1.price = card.price
        cart1.type = "c"
        cart1.generatedId = gene_id
        PersistanceService.saveContext()
        }
    }
    
  
    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel : BouquetViewModel!
    let refreshControl = UIRefreshControl()
    var scheduleId = ""

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getBouquetItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BouquetCell", for: indexPath) as! BouquetCell
        cell.displayContent(bouquet: viewModel.getBouquet(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 5
        let cellSpacing : CGFloat = 5
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        initializeBouquetList ()
        
 
    }

    @objc func refresh(sender:AnyObject) {
        self.page = 1
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.collectionView.reloadData()
        }
        initializeBouquetList()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CardVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? CardVC {
            chidVC.listener = self
            selectedtPosition = indexPath.row
        }
        self.present(newViewController, animated: true, completion: nil)
    }
  
   
  
    func initializeBouquetList()
    {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.getBouquets(page : self.page, limit: self.limit ,compleletion: {
            success in
            if success == true {
                self.loadMore = true
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()
                    self.collectionView.backgroundView = nil
                    self.collectionView.reloadData()
                }
            }
            else if  success == false && self.page == 1{
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()
                    self.collectionView.backgroundView = self.error_view
                }
            }else if success == false {
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()}
                self.loadMore = false
            }
            if self.page == 1 {
                self.stopActivityIndicator()
                
            }
        })
        
    }
    
    func bouquetAddedSuccessfully(){
     
        DispatchQueue.main.async {
            self.addedSuccessfully()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.getBouquetItemsCount() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    self.bottom_spinner.startAnimating()
                }
                page = page + 1;
                initializeBouquetList()
            }
        }
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

extension BouquetVC: Update {
    func updateTitle(id: String) {
        self.scheduleId = id
        print("id ",id)
    }
}
