//
//  ProductsVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProductsVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate
, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel : ProductsViewModel!
    let refreshControl = UIRefreshControl()
    var catID: String!
    var bottom_spinner = UIActivityIndicatorView()

    var page : Int = 1
    var limit : Int = 16
    var loadMore =  true

    @IBOutlet var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivityIndicator()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        initilizeCollectionView()
        
        self.bottom_spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.bottom_spinner.color = UIColor(hexString : "#DD3334")
        let x_axis : CGFloat = self.collectionView.frame.width / 2
        self.bottom_spinner.frame = CGRect(x: x_axis + 16 , y: self.collectionView.frame.height , width: 20, height: 20)
        //self.bottom_spinner.backgroundColor = .white
        self.view.addSubview(bottom_spinner)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_item", for: indexPath) as! Products_ViewCell
        cell.displayItem(gift: viewModel.getGift(indexPath: indexPath))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsProductList()
    }
    
    @IBAction func back_btn(_ sender: Any) {
        performSegueToReturnBack()
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
        initilizeCollectionView()
    }
    
    
    func initilizeCollectionView()
    {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.requestProductsList(limit:self.limit, page : self.page, catId: catID ,compeletion: {
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
                    self.collectionView.backgroundView = self.emptyDataView
                }
            }else if success == false {
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()}
                self.loadMore = false
            }
            if self.page == 1 || self.page == 2{
                self.stopActivityIndicator()
                
            }
        })
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItemsProductList() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    
                    self.bottom_spinner.startAnimating()
                    
                }
                page = page + 1;
                initilizeCollectionView()
            }
        }
    }
}



