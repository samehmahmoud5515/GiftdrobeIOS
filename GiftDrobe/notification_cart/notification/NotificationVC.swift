//
//  NotificationVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/28/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController , UITableViewDataSource , UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: NotificationViewModel!
    @IBOutlet var errorView: UIView!

    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.displayContent(notification: viewModel.getNotification(indexPath: indexPath))
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        initlist()
        
    }
    
    
    @objc func refresh(sender:AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
        initlist() 
   }
    
    func initlist() {
        self.startActivityIndicator()
        viewModel.requestData (limit: "" , page: "" , compeletion:{
            success in
            if success == true {
                DispatchQueue.main.async {
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                }
            } else {
                 DispatchQueue.main.async {
                    self.tableView.backgroundView = self.errorView
                }
            }
            self.stopActivityIndicator()
        })
    }

    

}
