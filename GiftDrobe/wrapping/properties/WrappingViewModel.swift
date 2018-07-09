//
//  WrappingViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/23/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class WrappingViewModel: NSObject {

    @IBOutlet var api: WrappingApi!
    var items : [WrappingItem]?
    var selectedItemsCount = 0
    
    func requestWrappings (cat_id: String ,compeletion: @escaping (Bool?) -> ()) {
        api.fetchData(cat_id: cat_id, compeletion: {
            json in
            if json == nil {
                compeletion(nil)
                return
            }
            if json?.wrapping_success == nil {
                compeletion(false)
            }
            if json?.wrapping_success == 1 {
                self.items = json?.wrapping
                compeletion(true)
            }else {
                compeletion(false)
            }
        })
    }
    
    func getNumberOfItemsList() -> Int {
        return items?.count ?? 0
    }
    func getWrappingItem (indexPath: IndexPath) -> WrappingItem {
        return items![indexPath.row]
    }
    func getWrappingId (indexPath: IndexPath) -> String {
        return items![indexPath.row].id!
    }
    func replaceItemInList (position: Int , selected: WrappingSelection,completion: ()-> () )
    {
        items![position].selectedItem = selected
        completion()
    }
    
    func replaceFirstCardItem (cardName: String) {
        items![0].selectedName = cardName
    }
    
    func getSelectedItemsCount() -> Int {
        selectedItemsCount = 0
        if let arr = items {
            for w in arr {
                if w.selectedItem?.id != nil  {
                    selectedItemsCount = selectedItemsCount + 1
                }
            }
        }
        return selectedItemsCount
    }
    
    func  getNumberOfRequired () -> Int {
        var count = 0
        for w in items! {
            if w.required == "1" {
                count = count + 1
            }
        }
        return count
    }
    
    func getWrappingsPrice () -> Float {
        var tottalPrice : Float = 0
        for w in items! {
            if let selectedItem = w.selectedItem {
                tottalPrice += (Float(selectedItem.price!) ?? 0)
            }
        }
        return tottalPrice
    }
    
    func getSelectedItem () -> [WrappingSelection] {
        var selectedItems : [WrappingSelection] = []
        if let arr = items {
            for w in arr {
                if  let  selectedItem = w.selectedItem {
                    selectedItems.append(selectedItem)
                }
            }
        }
        return selectedItems
    }
    
}
