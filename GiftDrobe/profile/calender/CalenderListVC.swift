//
//  CalenderListVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/4/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftMessages


class CalenderListVC: BaseViewController , UITableViewDelegate , UITableViewDataSource ,EventAdded {
 
    
    func onEventAdded() {
        self.page = 1
        DispatchQueue.main.async {
            self.viewModel.clearData()
            self.tableView.reloadData()
        }
        initList()
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: CalenderListViewModel!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var bottom_spinner : UIActivityIndicatorView!
    
    var page : Int = 1
    var limit : Int = 16
    var loadMore =  true

    @IBOutlet var errorView: UIView!
    var roundButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
        
        
        
        initList()
    }
    
 
    
    @objc func refresh(sender:AnyObject) {
        self.page = 1
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.tableView.reloadData()
        }
        self.initList()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return tableView == self.tableView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.startActivityIndicator()
            self.tableView.beginUpdates()
            self.tableView.reloadData()
            viewModel.deleteEvent(event: self.viewModel.getEvent(indexPath:indexPath).ID, compeletion : {
                success in
                if success == true {
                    self.deletionSuccessfully()
                } else {
                    self.deletionFailed()
                }
                self.stopActivityIndicator()
            })
            self.viewModel.removeItem(indexPath: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.white
        roundButton.clipsToBounds = true
        roundButton.setImage(#imageLiteral(resourceName: "plus64"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    
    @IBAction func ButtonClick(_ sender: UIButton){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddEventVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? AddEventVC {
            chidVC.finishListner = self
        }
        self.present(newViewController, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderListCell") as! CalenderListCell
        cell.displayContent(model:viewModel.getEvent (indexPath : indexPath))
        cell.backgroundColor = .clear

        
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddEventVC_nav") as! UINavigationController
        if let chidVC = newViewController.topViewController as? AddEventVC {
            chidVC.finishListner = self
            chidVC.event = viewModel.getEvent(indexPath: indexPath)
            print (viewModel.getEvent(indexPath: indexPath))
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    

  
    
    func initList()
    {
        if page == 1 {
            self.startActivityIndicator()}
        let usermanage = UserDataManager()
        let userId = usermanage.getUserId()
        self.viewModel.requestAllEvents(limit: self.limit, page : self.page,userId:userId ,completion: {
            success in
            if success == true {
                self.loadMore = true
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                }
            }
            else if  success == false && self.page == 1{
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()
                    self.tableView.backgroundView = self.errorView
                }
            }else if success == false {
                DispatchQueue.main.async {
                    self.bottom_spinner.stopAnimating()}
                self.loadMore = false
            }
            if self.page == 1 {
                self.stopActivityIndicator()
                
            }
        })
        
    }
    
    func deletionSuccessfully(){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✔"
            view.configureContent(title: "Sucessfull", body: "Event deleted successfully", iconText: iconText)
            SwiftMessages.show(view: view)
            
        }
    }
    
    func deletionFailed()
    {
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: "failed to delete event, try again", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItemsInSection() - 1)
        {
            if loadMore == true {
                DispatchQueue.main.async {
                    
                    self.bottom_spinner.startAnimating()
                    
                }
                page = page + 1;
                initList()
            }
        }
    }
  
}
