//
//  AddEventViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/13/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class AddEventViewModel: NSObject {
    
    @IBOutlet var api: AddEventAPI!
    var relations_arr : [RelationItem]? = []
    var occassion_arr : [OccasionItem]? = []

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
    
    func getRelationsArrString ()-> [String] {
        if let relations_arr_ = self.relations_arr {
            var relations_arr_String : [String] = []
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
            for i in 0...occasion_arr_.count-1 {
                occasion_arr_String.append(occasion_arr_[i].occasion!)
            }
            return occasion_arr_String
        }
        return []
    }
    
    func getRelationCount() -> Int {
        return relations_arr?.count ?? 0
    }
    
    func getOccassionCount() -> Int {
        return occassion_arr?.count ?? 0
    }
    
    func getOccassionStrById(occasion: String) -> String {
        for occ in occassion_arr! {
            if occ.occasion == occasion {
                return occ.id!
            }
        }
        return "Occasion"
    }
    
    func getRelationStrById(relation: String) -> String {
        for re in relations_arr! {
            if re.relations == relation {
                return re.id!
            }
        }
        return "Relationship"
    }
    
}
