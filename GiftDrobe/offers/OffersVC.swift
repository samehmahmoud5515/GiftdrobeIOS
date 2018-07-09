//
//  OffersVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/29/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class OffersVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel : OffersViewModel!
    let refreshControl = UIRefreshControl()
    //var bottom_spinner = UIActivityIndicatorView()
    @IBOutlet weak var bottom_spinner: UIActivityIndicatorView!

    var page : Int = 1
    var limit : Int = 14
    var loadMore =  true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        /*self.bottom_spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.bottom_spinner.color = UIColor(hexString : "#DD3334")
        let x_axis : CGFloat = self.collectionView.frame.width / 2
        self.bottom_spinner.frame = CGRect(x: x_axis + 26 , y: self.collectionView.frame.height , width: 50, height: 50)
        self.view.addSubview(bottom_spinner)*/
        
        initializeCollectionView()
   }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInTrendingList()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
        cell . displayContent(gift : viewModel.getGift(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetails_VC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? ProductDetails_VC {
            chidVC.productId = viewModel.getProductId(indexPath: indexPath)
        }
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 2
        let cellSpacing : CGFloat = 2
        let height_ : CGFloat = 200
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: height_)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        self.page = 1
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.collectionView.reloadData()
        }
        initializeCollectionView()
    }
    
    
   
    func initializeCollectionView()
    {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.requestOffersList(limit:self.limit, page : self.page ,completion: {
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItemsInTrendingList() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    
                    self.bottom_spinner.startAnimating()
                    
                }
                page = page + 1;
                initializeCollectionView()
            }
        }
    }


}
