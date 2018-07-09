//
//  SelectFlowerCustomizeVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SelectFlowerCustomizeVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel : SingleFlowerViewModel!
    @IBOutlet weak var errorView : UIView!
    let refreshControl = UIRefreshControl()
    var customFlowerAddProtocol : SetSelectedFlower? = nil
    var bottom_spinner = UIActivityIndicatorView()


    var page : Int = 1
    var limit : Int = 14
    var loadMore =  true

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getLitCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelcectFlowerCustomizeCell", for: indexPath) as! SelcectFlowerCustomizeCell
        cell.displayContent(flower: viewModel.getFlower(indexPath: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //SelectFlowerPropertiesVC
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SelectFlowerPropertiesVC") as! SelectFlowerPropertiesVC
        newViewController.flower = viewModel.getFlower(indexPath: indexPath)
        newViewController.customFlowerAddProtocol = self.customFlowerAddProtocol
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        initilizeList ()
        
        self.bottom_spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.bottom_spinner.color = UIColor(hexString : "#DD3334")
        let x_axis : CGFloat = self.collectionView.frame.width / 2
        self.bottom_spinner.frame = CGRect(x: (x_axis - 26) , y: self.collectionView.frame.height , width: 30, height: 30)
        self.view.addSubview(bottom_spinner)
    }
    
    @objc func refresh(sender:AnyObject) {
        self.page = 1
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.collectionView.reloadData()
        }
        initilizeList()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 5
        let cellSpacing : CGFloat = 5
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.getLitCount() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    self.bottom_spinner.startAnimating()
                }
                page = page + 1;
                initilizeList()
            }
        }
    }
    
   

    func initilizeList()
    {
        if page == 1 {
            self.startActivityIndicator()}
        self.viewModel.rquestFlowersList(limit: self.limit, page : self.page ,compeletion: {
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
                    self.collectionView.backgroundView = self.errorView
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
   
}


