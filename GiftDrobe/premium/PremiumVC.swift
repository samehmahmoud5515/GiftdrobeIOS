//
//  PremiumVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/17/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import CoreData

class PremiumVC: BaseViewController ,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , RefreshPremium {

    var page : Int = 1
    var limit : Int = 14
    var loadMore =  true
    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel : PremiumViewModel!
    @IBOutlet weak var cart_btn : BadgeBarButtonItem!
    var cart_arr = [Cart]()


    let refreshControl = UIRefreshControl()
    var bottom_spinner = UIActivityIndicatorView()


     func inilizeList() {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.requestPremiumList(limit:self.limit, page : self.page ,completion: {
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
    
    @objc func refresh(sender:AnyObject) {
        self.page = 1
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.collectionView.reloadData()
        }
        inilizeList()
    }
    
    func onRefreshPremium() {
        self.page = 1
        DispatchQueue.main.async {
            //self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.collectionView.reloadData()
        }
        inilizeList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        self.bottom_spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.bottom_spinner.color = UIColor(hexString : "#DD3334")
        let x_axis : CGFloat = self.collectionView.frame.width / 2
        self.bottom_spinner.frame = CGRect(x: x_axis + 26 , y: self.collectionView.frame.height , width: 30, height: 30)
        self.view.addSubview(bottom_spinner)
        
        inilizeList()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemInList()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PremiumCell", for: indexPath) as! PremiumCell
        cell.displayContent(gift: viewModel.getGift(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 3
        let cellSpacing : CGFloat = 3
        let height_ : CGFloat = 200
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: height_)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetails_VC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? ProductDetails_VC {
            chidVC.productId = viewModel.getGiftId(indexPath: indexPath)
        }
        self.present(newViewController, animated: true, completion: nil)
        
    }
  
    @IBAction func back_btn_action(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItemInList() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    
                    self.bottom_spinner.startAnimating()
                    
                }
                page = page + 1;
                inilizeList()
            }
        }
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
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstFilterVC") as! FirstFilterVC
        newViewController.premiumListener = self
        navigationController?.pushViewController(newViewController , animated: true)
    }
    
}
