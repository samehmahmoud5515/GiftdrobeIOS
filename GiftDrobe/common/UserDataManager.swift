//
//  UserDataManager.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/11/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation
class UserDataManager {
    let userIdKey = "userIdKey"
    let userImage = "userImage"
    let userName = "userName"
    let phone_ = "phone"
    let mail_ = "mail"
    let scheduleId = "scheduleId"
    let token_name_ = "token_name_"
    let merchant_ref_ = "merchant_ref_"

    func saveUserId(Id: String)  {
        UserDefaults.standard.set(Id, forKey: userIdKey)
    }
    func saveUserMail(mail: String)  {
        UserDefaults.standard.set(mail, forKey: mail_)
    }
    func saveScheduleId(scheduleId_: String)  {
        UserDefaults.standard.set(scheduleId_, forKey: scheduleId)
    }
    func saveToken_name(token_name: String) {
        UserDefaults.standard.set(token_name, forKey: token_name_)
    }
    func saveMerchantRef (merchant_ref: String) {
         UserDefaults.standard.set(merchant_ref, forKey: merchant_ref_)
    }
    func getMerchantRef ()-> String {
        guard let merchant_ref = UserDefaults.standard.string(forKey:merchant_ref_)
            else {
                return ""
        }
        return merchant_ref
    }
    
    func getToken_name()-> String {
        guard let token_name = UserDefaults.standard.string(forKey:token_name_)
            else {
                return ""
        }
        return token_name
    }
    
    func getScheduleId()-> String {
        guard let scheduleId = UserDefaults.standard.string(forKey:scheduleId)
            else {
                return "0"
        }
        return scheduleId
    }
    
    func savePhone(phone: String)  {
        UserDefaults.standard.set(phone, forKey: phone_)
    }
    func saveUserImage (image: String ) {
        UserDefaults.standard.set(image , forKey: userImage)
    }
    
    func saveUserName (name: String ) {
        UserDefaults.standard.set(name , forKey: userName)
    }
    func getUserName()-> String {
        guard let userId = UserDefaults.standard.string(forKey:userName)
            else {
                return ""
        }
        return userId
    }
    func getUserImage()-> String {
        guard let userId = UserDefaults.standard.string(forKey:userImage)
            else {
                return ""
        }
        return userId
    }
    func getUserPhone()-> String {
        guard let phone = UserDefaults.standard.string(forKey:phone_)
            else {
                return "01"
        }
        return phone
    }
    func getUserMail()-> String {
        guard let mail = UserDefaults.standard.string(forKey:mail_)
            else {
                return ""
        }
        return mail
    }
    func getUserId()-> String {
       guard let userId = UserDefaults.standard.string(forKey:userIdKey)
        else {
            return ""
        }
       return userId
        
    }
    
    func removeUserData()
    {
        UserDefaults.standard.removeObject(forKey:userIdKey)
    }
}
