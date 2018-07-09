//
//  ViewController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/21/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import Foundation
import ImageSlideshow
import Kingfisher
import UserNotifications

class CategoriesVC: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    
    @IBOutlet var viewModel : CategoriesViewModel!
    let logoDownloadNotificationID = "com.iosbrain.logoDownloadCompletedNotificationID"
    @IBOutlet var error_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        initilizeView()
        
        //observer when cats checked changed
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishDownloading), name: Notification.Name(rawValue: logoDownloadNotificationID), object: nil)
        
        //requesting for authorization
     /*   UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        */
       /* self.viewModel.fetchScheduling(completion: {
            count in
            if count > 0 {
                self.localNotification(badge: count)
            }else {
                 DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        })
        self.viewModel.fetchCalender(compeletion:{
            count in
            if count > 0 {
                self.localNotification(badge: count, after: 5 ,title:"Calender event today",
                                       subtitle: "You've calender event today" ,
                                       body: "Open my calender")
            }else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        })*/
    }
    
  /*  func localNotification (badge: Int, after: Int = 2 ,title: String = "Scheduling flowers today",
                            subtitle: String = "You've scheduling flowers today" ,
                            body: String = "open scheduling to either delete or confirm" ) {
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge as NSNumber
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(after), repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }*/

    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: logoDownloadNotificationID), object: nil)
    }
    
    @objc func didFinishDownloading()
    {
        DispatchQueue.main.async {
            self.initilizeView() }
    }
  
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat_cell", for: indexPath) as! Categories_ViewCell
        cell.displayContent(category: viewModel.getCategory(indexPath: indexPath))
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProductsVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? ProductsVC {
            chidVC.catID = viewModel.getCategoriesId(indexPath: indexPath)
        }
        self.present(newViewController, animated: true, completion: nil)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 4
        let cellSpacing : CGFloat = 4
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if viewModel.getSliderImages() == nil {
            return CGSize(width: collectionView.bounds.width, height: 38) }
        else {
            return CGSize(width: collectionView.bounds.width, height: 260)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "cat_header"
        , for: indexPath) as! CollectionViewHeader
    
        headerView.displayContent(inputs: viewModel.getSliderImages())
        return headerView
    }
    
    
    @objc func refresh(sender:AnyObject) {
       DispatchQueue.main.async {
        self.refreshControl.endRefreshing() }
       initilizeView ()
    }
 
    func initilizeView ()
    {
        self.startActivityIndicator()

        viewModel.fetchData {
            sucess in
            if sucess == true {
            DispatchQueue.main.async {
          
                self.collectionView.backgroundView = UIView(frame: CGRect.zero)
                self.stopActivityIndicator()
                self.collectionView.reloadData()
           
            }
            }else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = self.error_view
                    
                }
            }
            self.stopActivityIndicator()
        }
    }
    
}




