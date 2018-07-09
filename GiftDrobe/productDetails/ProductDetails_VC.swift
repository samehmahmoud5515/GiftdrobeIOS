//
//  ProductDetails_VC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher



class ProductDetails_VC: BaseViewController ,UICollectionViewDelegate , UICollectionViewDataSource ,GoToCart ,BackToProductDetails ,UICollectionViewDelegateFlowLayout ,UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var similarProductsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var  myConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var line_iv: UIImageView!
    @IBOutlet weak var go_wrapping_btn: UIButton!
    @IBOutlet weak var brand_name_label: UILabel!
    @IBOutlet weak var supplier_label: UILabel!

    
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var product_name_label: UILabel!
    @IBOutlet weak var similar_products_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    var count = 1
    
    @IBOutlet var viewModel  : ProductDetailsViewModel!
    var gift : Gift?
    var productId : String?
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
    func goToCart() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CartVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func  onBackToProductDetails() {
        self.performSegueToReturnBackWithNoAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.getNumberOfProductImages()
        }else {
            if self.viewModel.getOtherGiftsSize() == 0 {
                DispatchQueue.main.async {
                    self.similar_products_label.isHidden = true
                    self.myConstraint.constant = 700
                    self.containerView.layoutIfNeeded()
                }
            }else if self.viewModel.getOtherGiftsSize() == 2 {
                DispatchQueue.main.async {
                     self.similar_products_label.isHidden = false
                    self.myConstraint.constant = 900
                    self.containerView.layoutIfNeeded()
                }
            }else if self.viewModel.getOtherGiftsSize() > 2  {
                DispatchQueue.main.async {
                     self.similar_products_label.isHidden = false
                    self.myConstraint.constant = 1130
                    self.containerView.layoutIfNeeded()
                }
            }
            return viewModel.getOtherGiftsSize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == similarProductsCollectionView {
            let numberOfColoums : CGFloat = 2
            let width = self.similarProductsCollectionView.frame.size.width
            let xInsets : CGFloat = 3
            let cellSpacing : CGFloat = 4
            let height_ : CGFloat = 200
            return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: height_)
        }else {
            return  CGSize(width: 57  , height: 62)
        }
     }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images_cv", for: indexPath) as! ProductDetailsImagesCell
        cell.displacContent(imageString: viewModel.getGiftImage(indexPath: indexPath))
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarProductsCell", for: indexPath) as! SimilarProductsCell
            cell.displayContent(other: viewModel.getOtherGifts(indexPath: indexPath))
            return cell
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            imageSlider.setCurrentPage(indexPath.row, animated: true)
        }else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetails_VC_nav") as! UINavigationController
            if let chidVC = newViewController.topViewController as? ProductDetails_VC {
                chidVC.productId = viewModel.getProductId(indexPath: indexPath)
            }
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    

    //images_cv
    override func viewDidLoad() {
        super.viewDidLoad()
        self.go_wrapping_btn.setTitle("Select to continue", for: .normal)
        DispatchQueue.main.async {
            self.hideViews()}
        
        imageSlider.zoomEnabled = true
        self.startActivityIndicator()
        viewModel.getProductDetails(produtId: productId!, compeletion: {
            gift in
            self.gift = gift
        
            if gift != nil
            {
            DispatchQueue.main.async {
                self.showViews()
                self.collectionView.reloadData()
            self.product_name_label.text = gift?.name
                self.price_label.text = ((gift?.price)! + " EGP")
            self.description_label.text = gift?.description
                self.brand_name_label.text = gift?.brand
                self.supplier_label.text = gift?.supplier
                self.imageSlider.setImageInputs(self.getSliderImages()!)
                self.similarProductsCollectionView.reloadData()
                if self.viewModel.getOtherGiftsSize() > 0 {
                    self.similar_products_label.isHidden = false
                }
               /* self.scrollView.contentSize = CGSize( width:  self.scrollView.frame.size.width , height: self.similarProductsCollectionView.contentSize.height + self.scrollView.frame.size.width
                  )*/
            }
            } else {
                 DispatchQueue.main.async {
                    self.error_view.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
                    self.view.addSubview(self.error_view)
                }
            }
                self.stopActivityIndicator()
        })
        
       /* scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: scrollViewContentHeight)*/
        scrollView.delegate = self
        similarProductsCollectionView.delegate = self
        scrollView.bounces = false
        similarProductsCollectionView.bounces = false
        similarProductsCollectionView.isScrollEnabled = false
        
        
      
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollViewContentHeight - screenHeight {
                //scrollView.isScrollEnabled = false
                similarProductsCollectionView.isScrollEnabled = true
            }
        }
        
        if scrollView == self.similarProductsCollectionView {
            if yOffset <= 0 {
                self.scrollView.isScrollEnabled = true
                self.similarProductsCollectionView.isScrollEnabled = false
            }
        }
    }

    
    

    @IBAction func go_wrapping_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WrappingSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "wrappingProperties_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? WrappingPropertiesVC {
            chidVC.gift = self.gift
            chidVC.listener = self
            chidVC.backListener = self
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    
   
    func getSliderImages() -> [InputSource]? {
        var inputs : [InputSource]? = []
        guard let gift_ = self.gift else {
            return nil
        }
        guard let img_arr = gift_.images else {
            return nil
        }
        for img in img_arr {
             let img_replaced = img.replacingOccurrences(of: " ", with: "%20")
             inputs?.append( KingfisherSource(urlString: img_replaced)!)
        }
        return inputs
    }
    
    @IBAction func back_btn_action(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    func hideViews()
    {
        similar_products_label.isHidden = true
        similarProductsCollectionView.isHidden = true
        collectionView.isHidden = true
        description_label.isHidden = true
        price_label.isHidden = true
        imageSlider.isHidden = true
        product_name_label.isHidden = true
        line_iv.isHidden = true
        go_wrapping_btn.isHidden = true
        brand_name_label.isHidden = true
        supplier_label.isHidden = true
    }
    func showViews()
    {
        similarProductsCollectionView.isHidden = false
        collectionView.isHidden = false
        description_label.isHidden = false
        price_label.isHidden = false
        imageSlider.isHidden = false
        product_name_label.isHidden = false
        line_iv.isHidden = false
        go_wrapping_btn.isHidden = false
        brand_name_label.isHidden = false
        supplier_label.isHidden = false
    }
    
    
    
}


