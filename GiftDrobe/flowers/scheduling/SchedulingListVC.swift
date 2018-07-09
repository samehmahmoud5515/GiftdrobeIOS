//
//  SchedulingListVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/13/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages


class SchedulingListVC: BaseViewController, UITableViewDelegate , UITableViewDataSource  {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet var viewModel: SchedulingListViewModel!
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingListCell") as! SchedulingListCell
        cell.displayContent(item: self.viewModel.getListItem(indexPath: indexPath))
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.startActivityIndicator()
            tableView.beginUpdates()
            tableView.reloadData()
            viewModel.deleteSchedule(s_id: self.viewModel.getListItem(indexPath:indexPath).id!, compeletion : {
                success in
                if success == true {
                    self.deletionSuccessfully()
                } else {
                    self.deletionFailed()
                }
                self.stopActivityIndicator()
            })
            self.viewModel.removeItem(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.viewModel.clearData()
            self.tableview.reloadData()
        }
        initList()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addBtn = UIButton()
        addBtn.frame = CGRect(x: self.view.frame.size.width - 66, y: self.view.frame.size.height - 100, width: 50, height: 50)
        addBtn.setImage(#imageLiteral(resourceName: "plus64"), for: .normal)
        addBtn.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        self.navigationController?.view.addSubview(addBtn)
        self.initList()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableview.refreshControl = refreshControl
    }

    @objc func addButtonAction() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "new")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func initList () {
        self.startActivityIndicator()
        self.viewModel.getList(completion: {
            success in
            if success == true {
                 DispatchQueue.main.async {
                    self.tableview.backgroundView = nil
                    self.tableview.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.tableview.backgroundView = self.errorView
                }
            }
            self.stopActivityIndicator()
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
            view.configureContent(title: "Sucessfull", body: "Schedule deleted successfully", iconText: iconText)
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
            view.configureContent(title: "Error", body: "failed to delete Schedule, try again", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }

}
