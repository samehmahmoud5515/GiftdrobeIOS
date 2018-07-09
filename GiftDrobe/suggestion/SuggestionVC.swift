//
//  SuggestionVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SuggestionVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet var viewModel : SuggestionViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var error_view: UIView!
    let refreshControl = UIRefreshControl()
    var bottom_spinner = UIActivityIndicatorView()
   // var listener: SuggestionDismissed?
    
    var page : Int = 1
    var limit : Int = 14
    var loadMore =  true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        self.bottom_spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.bottom_spinner.color = UIColor(hexString : "#DD3334")
        let x_axis : CGFloat = self.collectionView.frame.width / 2
        self.bottom_spinner.frame = CGRect(x: x_axis + 26 , y: self.collectionView.frame.height , width: 50, height: 50)
        self.view.addSubview(bottom_spinner)
        
        callApi()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInCollectionView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
        cell . displayContent(gift: viewModel.getGift(indexPath: indexPath))
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
        let xInsets : CGFloat = 3
        let cellSpacing : CGFloat = 3
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
        callApi()
    }
    
    
    func callApi()
    {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.fetchRecentData(limit: self.limit, page : self.page ,compeletion: {
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
        if indexPath.row == (viewModel.numberOfItemsInCollectionView() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    
                    self.bottom_spinner.startAnimating()
                    
                }
                page = page + 1;
                callApi()
            }
        }
    }
     @IBAction func once_btn_action(_ sender: Any) {
        self.performSegueToReturnBack()
    }
 
}


