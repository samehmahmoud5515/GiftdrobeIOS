//
//  SearchViewController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/30/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SearchViewController:  BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet var viewModel: SearchViewModel!
    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var word : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initList ()
      
    }

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
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
        let xInsets : CGFloat = 2
        let cellSpacing : CGFloat = 2
        let height_ : CGFloat = 200
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: height_)
        
    }
    
    func initList () {
        self.startActivityIndicator()
        viewModel.getList(word: word, compeletion: {
            success in
            if success == true {
                 DispatchQueue.main.async {
                     self.collectionView.backgroundView = nil
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = self.error_view
                }
            }
            self.stopActivityIndicator()
        })
        
    }
  
}
