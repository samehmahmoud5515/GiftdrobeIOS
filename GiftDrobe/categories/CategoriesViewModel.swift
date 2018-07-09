//
//  CategoriesViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/2/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher
import UserNotifications

public class CategoriesViewModel: NSObject {

   @IBOutlet var homeClient : HomeClientAPI!
    var home_model : HomeModel?
    @IBOutlet var schedulingAPI : SchedulingAPI!
    @IBOutlet var calenderAPI : CalenderListAPI!
    func fetchData (completion : @escaping (Bool?) -> () )
    {
        
        homeClient.fetchData{home_model in
            self.home_model = home_model
            if home_model != nil {
            if home_model?.categories_success == 1
            {
                completion(true)
            }
            else {
                completion(false)
            }
            }else {
                completion(false)
            }
        }
        
    }
    var scheduling_arr:[ScheduleModel]? = []
    func fetchScheduling(completion:  @escaping (Int) -> ()) {
        let userManger = UserDataManager()
        self.schedulingAPI.getScheduleList(userId: userManger.getUserId() , compeletion: {
            json in
            if json != nil {
                self.scheduling_arr = json?.schedule
                var count = 0
                if let arr = self.scheduling_arr {
                    for sh in arr {
                        if sh.today == "1" {
                            count = count + 1
                        }
                    }
                }
                 completion(count)
            } else {
                completion(0)
            }
        })
    }
     var events : [EventModel]? = []
    func fetchCalender(compeletion: @escaping (Int) -> () ) {
        let userManger = UserDataManager()
        calenderAPI.getAllEventsFromApi(limit: "16", page : "1",user: userManger.getUserId() , compeletion: {
            json in
            if json == nil || json?.events == nil {
                compeletion(0)
            }
            if json?.success == 1 {
                self.events = json?.events
                 var count = 0
                if let arr = self.events {
                    for g in arr {
                        if g.today == "1" {
                            count = count + 1
                        }
                    }
                }
                compeletion(count)
            } else {
                compeletion(0)
            }
        })
            
    }
   
 
    func numberOfItemsInSection (section: Int) -> Int
    {
        return home_model?.categories?.count ?? 0
    }
    func categoriesName(indexPath: IndexPath) -> String {
        return (home_model?.categories![indexPath.row].name) ?? ""
    }
    
    func getCategoriesId (indexPath : IndexPath) -> String {
        return (home_model?.categories![indexPath.row].id) ?? ""
 
    }
    func getCategory (indexPath: IndexPath) -> CategoriesModel {
        return (home_model?.categories![indexPath.row])!
    }
    func getSliderImages() -> [InputSource]? {
        var inputs : [InputSource]? = []
        guard let homeModel = self.home_model else {
            return nil
        }
        guard let offers_arr = homeModel.offers else {
            return nil
        }
        for offer in offers_arr {
           
            if let  img = offer.gift_image {
                let img_rep = img.replacingOccurrences(of: " ", with: "")
                inputs?.append(  KingfisherSource(urlString: img_rep)!)
            }
          
        }
        return inputs
    }
}
