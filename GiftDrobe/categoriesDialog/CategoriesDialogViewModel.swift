//
//  CategoriesDialogViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CategoriesDialogViewModel: NSObject {

    var cat_api: CategoriesDialogAPI?
    @IBOutlet var api_service : CategoriesDialogServiceAPI!
    
    func fetchData (completion : @escaping (Bool?) -> () )
    {
        
        api_service.fetchData{cat_api in
            if cat_api == nil {
                completion(false)
            }else {
                self.cat_api = cat_api
                completion(true)
            }
        }
        
    }
    
    
    func numberOfItemsInSection(section: Int) -> Int {
       return cat_api?.categories?.count ?? 0
    }
    
    func categoriesName(indexPath: IndexPath) -> String {
        return (cat_api?.categories![indexPath.row].name) ?? ""
    }
    
    func getCategory (indexPath: IndexPath) -> CategoriesDialogModel {
        return (cat_api?.categories![indexPath.row])!
    }
    
    func filerWithCategories (catIds: [String],completion: @escaping (Bool?) -> () )
    {
        api_service.submitFilter(catIds: catIds ,completion: {
            success in
            completion(success)
        })
    }
}
