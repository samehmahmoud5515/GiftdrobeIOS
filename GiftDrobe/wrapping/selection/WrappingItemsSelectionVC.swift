//
//  WrappingItemsSelectionVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/26/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingItemsSelectionVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate,
       UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var viewModel : WrappingSelectionViewModel!
    public var listener : OnItemSelected!
    public var parent_position: Int?
    public var parent_id : String!
    public var parent_name : String!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var parent_name_label: UILabel!
    var gift_id : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent_name_label.text = parent_name
        initlizeList ()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WrappingItemSellectionCell", for: indexPath) as! WrappingItemSellectionCell
        cell.displayContent(wrappingSelcection:viewModel.getSelction(indexPath: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener.onItemSelected(position: parent_position! , wrappingSelection : viewModel.getSelction(indexPath: indexPath))
        performSegueToReturnBack()
    }
    
    @IBAction func back_btn_action(_ sender: Any) {
        performSegueToReturnBack()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 5
        let cellSpacing : CGFloat = 5
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
        
    }
    
    func initlizeList ()
    {
        self.startActivityIndicator()
       
        
        viewModel.requestItems(id: parent_id, giftId : gift_id, completion: {
            success in
            if success == true {
                DispatchQueue.main.async {
                      self.collectionView.backgroundView = nil
                      self.collectionView.reloadData()
                    
                }
            }else {
                  DispatchQueue.main.async {
                    self.collectionView.backgroundView = self.errorView
                }
            }
            self.stopActivityIndicator()
        })
    }
 
  
}

 protocol OnItemSelected{
    func onItemSelected(position: Int , wrappingSelection : WrappingSelection)
}
