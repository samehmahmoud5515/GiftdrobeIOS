//
//  FilterViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class FilterViewModel: NSObject {

    @IBOutlet var api: FilterAPI!
    var relations_arr : [RelationItem]? = []
    var occassion_arr : [OccasionItem]? = []
    
    
    func getRelationCount() -> Int {
        return relations_arr?.count ?? 0
    }
    
    func getOccassionCount() -> Int {
        return occassion_arr?.count ?? 0
    }
    
    func requestRelations (completion : @escaping (Bool?) -> () ) {
        api.fetchRelationList( compeletion: {
            relationJson in
            guard relationJson != nil && relationJson?.relations != nil else {
                completion(false)
                return
            }
            if relationJson?.relations_success == 1 {
                self.relations_arr = relationJson?.relations
                completion(true)
            } else {
                completion(false)
            }
            
            
        })
    }
    
    func skipFilter(completion: @escaping (Bool)-> () ) {
        api.clearFilter (completion: {success in
            completion(success)
        })
    }
    
    func getRelationsArrString ()-> [String] {
        if let relations_arr_ = self.relations_arr {
            var relations_arr_String : [String] = []
          /*  if relations_arr_String.count == 0 {
                return []
            }*/
            for i in 0...relations_arr_.count-1 {
                relations_arr_String.append(relations_arr_[i].relations!)
            }
            return relations_arr_String
        }
        return []
    }
    
    func getRelationId (position: Int) -> String {
        return relations_arr?[position].id ?? "-1"
    }
    
    func requestOcassion (completion : @escaping (Bool?) -> () ) {
        api.fetchOccassionList( compeletion: {
            occassionJson in
            guard occassionJson != nil && occassionJson?.occasions != nil else {
                completion(false)
                return
            }
            if occassionJson?.occasion_success == 1 {
                self.occassion_arr = occassionJson?.occasions
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func getOccassionId (position: Int) -> String {
        return occassion_arr?[position].id ?? "-1"
    }
    
    func getOccassionArrString () -> [String] {
        if let occasion_arr_ = self.occassion_arr {
            var occasion_arr_String : [String] = []
           /* if occasion_arr_String.count == 0 {
                return []
            }*/
            for i in 0...occasion_arr_.count-1 {
                occasion_arr_String.append(occasion_arr_[i].occasion!)
            }
            return occasion_arr_String
        }
        return []
    }
    
    func submitFiler(age:String, from: String , to: String , occasion: String, relation : String ,
                      update_flag: String , type: String
        ,completion : @escaping (Bool?) -> () ) {
        
        api.submitFilter(age: age, from: from, to: to, occasion: occasion, relation: relation, update_flag: update_flag, type: type, completion: {
            success in
            if success == true {
                completion(true)
            } else {
                 completion(false)
            }
        })
    }
    
}
