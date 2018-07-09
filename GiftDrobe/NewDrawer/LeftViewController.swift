//
//  leftViewController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/27/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData



class LeftViewController : UIViewController  , UITableViewDelegate
, UITableViewDataSource , OnDrawerMenuClicked , UITextFieldDelegate{
    func onDrawerMenuClicked(position: Int) {
        if position == 2
        {
            self.closeLeft()
            openCategoriesDialog()
        }
        else if position == 6
        {
            self.closeLeft()
            openFlowers()
        }
        else if position == 0
        {
            self.closeLeft()
            openProfile()
        }
        else if position == 5
        {
             self.closeLeft()
             openPreiuium()
        }
        else if position == 1
        {
            self.closeLeft()
            openCalender ()
        }
        else if position == 9
        {
            self.closeLeft()
            siginOut()
        }
        else if position == 4 {
            self.closeLeft()
            openSuggestion ()
        }
        else if position == 8 {
            self.closeLeft()
            self.shareAppAction()
        }
    }
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profile_image_view: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
  
    @IBOutlet var api: CalenderListAPI!
    var calenderSize: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        profile_image_view.layer.borderWidth = 1.0
        profile_image_view.layer.masksToBounds = false
        profile_image_view.layer.borderColor = UIColor.white.cgColor
        profile_image_view.layer.cornerRadius = profile_image_view.frame.size.width / 2
        profile_image_view.clipsToBounds = true
        
        tableView.separatorColor = UIColor.black

        let userManager = UserDataManager()
        let image = userManager.getUserImage()
        let url = URL(string: image)
        let image_ = UIImage(named: "placeholder")
        profile_image_view.kf.setImage(with: url,placeholder: image_)
        userNameLabel.text = userManager.getUserName().replacingOccurrences(of: "%20", with: " ")
        
        search_txt_view.delegate = self
        let usermanage = UserDataManager()
        let userId = usermanage.getUserId()
        api.getAllEventsFromApi(limit: "" , page : "",user: userId , compeletion: {
            json in
            if json == nil || json?.events == nil || json?.success == nil {
                return
            }
            if json?.success == 1 {
                if let arr : [EventModel] = json?.events{
                   self.calenderSize = arr.count
                      DispatchQueue.main.async {
                        self.tableView.reloadData()
                     }
                }
                
            } else {
                
            }
            
        })

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == search_txt_view {
            search_txt_view.resignFirstResponder()
            self.search_action()
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawer_menu_item", for: indexPath) as! DrawerCell
        cell.displayContent(position : indexPath.item,calenderCount: self.calenderSize, listner_: self)
       
        return cell
    }
    
    func openCategoriesDialog()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CategoriesDialogVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    func openFlowers()  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Once_or_Scheduled_VC_nav")
        self.present(newViewController, animated: true, completion: nil)
       
    }
    
    func openProfile ()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func openPreiuium()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PremiumVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func openCalender ()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CalenderListVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func siginOut()
    {
        let manager = UserDataManager()
        manager.saveUserId(Id: "")
        manager.saveUserImage(image: "")
        manager.saveUserName(name: "")
        manager.saveUserMail(mail: "")
        manager.savePhone(phone: "")
        manager.saveToken_name(token_name: "")
        
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        let storyBoard: UIStoryboard = UIStoryboard(name: "SiginingSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC_nav")
        self.present(newViewController, animated: true, completion: nil)
        self.eraseCart()
    }
    
    func openSuggestion () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SugggestionVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var search_txt_view: UITextField!
    
    @IBOutlet weak var search_btn: UIButton!
    @IBAction func search_btn_action(_ sender: UIButton) {
       self.search_action()
    }
    
     func search_action() {
        if search_txt_view.text != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController_nav") as! UINavigationController
            if let chidVC = newViewController.topViewController as? SearchViewController {
                chidVC.word = search_txt_view.text!
            }
            self.present(newViewController, animated: true, completion: nil) }
     }
    
    func eraseCart()  {
        
        let car_delete_req = NSBatchDeleteRequest(fetchRequest: Cart.fetchRequest())
        do {
            try PersistanceService.context.execute(car_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let w_delete_req = NSBatchDeleteRequest(fetchRequest: Wrappings.fetchRequest())
        do {
            try PersistanceService.context.execute(w_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let b_delete_req = NSBatchDeleteRequest(fetchRequest: Bouquet.fetchRequest())
        do {
            try PersistanceService.context.execute(b_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let f_delete_req = NSBatchDeleteRequest(fetchRequest: Flowers.fetchRequest())
        do {
            try PersistanceService.context.execute(f_delete_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let add_req = NSBatchDeleteRequest(fetchRequest: Address.fetchRequest())
        do {
            try PersistanceService.context.execute(add_req)
            try PersistanceService.context.save()
        } catch {
            print ("There was an error")
        }
        let userMana = UserDataManager()
        userMana.saveScheduleId(scheduleId_:"0")
    }
    
    func shareAppAction() {
       
        let someText:String = "Giftdrobe"
        let objectsToShare:URL = URL(string: "https://itunes.apple.com/eg/app/giftdrobe/id1391071688?mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}


    

