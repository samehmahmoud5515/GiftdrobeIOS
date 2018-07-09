//
//  CategoriesDialogVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/29/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages

class CategoriesDialogVC: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, CheckBoxChecked {
  
     let categoriesVC = CategoriesVC()
    let logoDownloadNotificationID = "com.iosbrain.logoDownloadCompletedNotificationID"

    var selected_cat_arr: [CategoriesDialogModel] = []
    func onCheckboxChecked(cat: CategoriesDialogModel) {
        selected_cat_arr.append(cat)
    }
    
    func onCheckboxUnChecked(cat: CategoriesDialogModel) {
        if let i = selected_cat_arr.index(where: { $0.id == cat.id }) {
            selected_cat_arr.remove(at: i )
        }
        
    }
    
   /* func onSuggestionDismissed() {
        self.performSegueToReturnBackWithNoAnimation()
    }*/
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewModel: CategoriesDialogViewModel!
    @IBOutlet weak var errorView: UIView!
    
    @IBAction func ok_btn_action(_ sender: Any) {
        //performSegueToReturnBackWithNoAnimation()
        var selected_cat_str_arr : [String] = []
        for cat_obj in selected_cat_arr {
            selected_cat_str_arr.append(cat_obj.id!)
        }
        if selected_cat_str_arr.count != 0 {
        self.startActivityIndicator()
        self.viewModel.filerWithCategories(catIds: selected_cat_str_arr , completion : {
            success in
            if success == true {
                self.performSegueToReturnBackWithNoAnimation()
           
                NotificationCenter.default.post(name: Notification.Name(rawValue: self.logoDownloadNotificationID), object: self)
            }
            self.stopActivityIndicator()
        })
        }else {
            self.selectionFailed()
        }
    }
    
    @IBAction func cancel_btn_action(_ sender: Any) {
        self.performSegueToReturnBackWithNoAnimation()
     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesDialogCell", for: indexPath) as! CategoriesDialogCell
        cell.displayContent(cat: viewModel.getCategory(indexPath: indexPath), listener: self)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivityIndicator()
        viewModel.fetchData { success in
            if success == true {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = nil
                    self.collectionView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = self.errorView }
            }
            self.stopActivityIndicator()
        }
       

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 1
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 0
        let cellSpacing : CGFloat = 0
        let height_ : CGFloat = 45
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: height_)
        
    }
    
    func selectionFailed(msg: String = "Please select at least one category")
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }

}

protocol RefreshCategories {
    func refeshCats()
}



