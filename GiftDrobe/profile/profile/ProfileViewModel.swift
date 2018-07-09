//
//  ProfileViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/1/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {

    @IBOutlet var api : ProfileAPI!
    var user: UserJson?
    var relations_arr : [RelationItem]? = []
    var relationship_id: String? = ""
    
    func getUserData (id: String,compeletion: @escaping (Bool?)->() ) {
        api.getUserDataFromAPI(id: id , compeletion: {
            json in
            
            if json == nil || json?.user?[0] == nil {
                compeletion(false)
            } else {
                if json?.success == 1 {
                    self.user = json?.user![0]
                    compeletion(true)
                } else {
                    compeletion(false)
                }
            }
            
        })
    }
    
    func getName ()-> String {
        if  var u_name : String = self.user?.name {
            u_name = u_name.replacingOccurrences(of: "%20", with: " " )
            return u_name
        }
        return  ""
    }
    func getEmail () -> String {
        return self.user?.email ?? ""
    }
    func getPhone () -> String {
        return self.user?.mobile ?? ""
    }
    func getPassword () -> String {
        return self.user?.password ?? ""
    }
    func getGender () -> String {
        if self.user?.sex  == "0" {
            return "Male"
        } else if self.user?.sex  == "1" {
            return "Female"
        }
        return "Gender"
    }
    
    func getDateOfBirth () -> String {
        return self.user?.age ?? ""
    }
    
    func getRelationship () -> String {
        relationship_id = self.user?.relationship ?? ""
        return self.user?.relationship ?? ""
    }
    
    func getRelationshipById () -> String {
        _ = getRelationship()
        if let relations_arr_ = self.relations_arr {
            for i in 0...relations_arr_.count-1 {
                if relationship_id == relations_arr_[i].id {
                    return relations_arr_[i].relations ?? ""
                }
            }
            return ""
        }
        return ""
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
    
    func editUserData(id:String,email: String ,password: String ,username: String , phone: String ,age: String
        ,relationship: String , gender: String
        ,compeletion:@escaping (Bool?)->() ) {
        
        api.editUserDataFromAPI(id: id, email: email, password: password, username: username, phone: phone, age: age, relationship: relationship, gender: gender, compeletion: {json in
            if json == nil || json?.user?[0] == nil {
                compeletion(false)
            } else {
                if json?.success == 1 {
                    self.user = json?.user![0]
                    compeletion(true)
                } else {
                    compeletion(false)
                }
            }
        })
    }
    
}







