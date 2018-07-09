//
//  AddEventVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/4/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import DropDown
import SwiftMessages



class AddEventVC: BaseViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var relationship_btn: UIButton!
    @IBOutlet weak var occassion_btn: UIButton!
    @IBOutlet weak var occassion_activity_indicator: UIActivityIndicatorView!
    @IBOutlet weak var relationship_activity_indicator: UIActivityIndicatorView!
    @IBOutlet var viewModel: AddEventViewModel!

    @IBOutlet weak var add_btn: UIButton!
    @IBOutlet weak var date_val_label: UILabel!

    
    @IBOutlet var api : AddEventAPI!
    var occasionId : String = ""
    var relationId : String = ""
    var finishListner: EventAdded?
    var event : EventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        relationship_activity_indicator.startAnimating()
        occassion_activity_indicator.startAnimating()
        viewModel.requestRelations(completion: {
            _ in
             DispatchQueue.main.async {
                self.relationship_activity_indicator.stopAnimating()
                self.relationship_activity_indicator.isHidden = true

            }
        })
        viewModel.requestOcassion(completion: {
            _ in
             DispatchQueue.main.async {
                self.occassion_activity_indicator.stopAnimating()
                self.occassion_activity_indicator.isHidden = true

            }
        })
        
        guard let event_ = event else {
            self.add_btn.setTitle("Add to calender", for: .normal)
            self.date_val_label.isHidden = true
            return
        }
        
        
            self.occassion_btn.setTitle(event_.occasion  , for: .normal)
            self.relationship_btn.setTitle(event_.relation  , for: .normal)
            self.add_btn.setTitle("Edit", for: .normal)
            self.date_val_label.isHidden = false
            self.date_val_label.text = event_.date
            self.relationId = event_.relation_id ?? ""
            self.occasionId = event_.occasion_id ?? ""
        
    }

    @IBAction func occasion_btn_action(_ sender: Any) {
        if viewModel.getOccassionCount() == 0 {
            return
        }
        let dropDown = DropDown()
        dropDown.anchorView = occassion_btn
        dropDown.dataSource = self.viewModel.getOccassionArrString()
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.occassion_btn.setTitle(item, for: .normal)
            self.occasionId = self.viewModel.getOccassionId(position: index)
        }
        dropDown.show()
    }
    
    @IBAction func relationship_btn_action(_ sender: Any) {
        if viewModel.getRelationCount() == 0 {
            return
        }
        let dropDown = DropDown()
        dropDown.anchorView = relationship_btn
        dropDown.dataSource = self.viewModel.getRelationsArrString()
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.relationship_btn.setTitle(item, for: .normal)
            self.relationId = self.viewModel.getRelationId(position: index)
        }
        dropDown.show()
    }
    
    func addedSuccessfully(){
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✔"
            view.configureContent(title: "Sucessfull", body: "Added Successfully", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    func addedFailed(message : String)
    {
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: message , iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }

    
    @IBAction func addEventBtnAction(_ sender: Any) {
        
        if occasionId == "" || relationId == "" {
            self.addedFailed(message:"select all fields")
            return
        }
        
        self.startActivityIndicator()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datePicker.date)
        let userManager = UserDataManager()
        let userId = userManager.getUserId()
        
        if event == nil {
            api.addNewEventApi(userId: userId ,date: dateString ,relation: relationId ,occasion :occasionId, compeletion :{
            json in
            self.stopActivityIndicator()
                if json?.success == 1 {
                    self.finishListner?.onEventAdded()
                    self.addedSuccessfully()
                    DispatchQueue.main.async {
                        self.performSegueToReturnBack()  }
                } else {
                    self.addedFailed(message: "failed to add event, please try again")
                }
        })
        } else {
        
            api.updateEventApi(eventId: event?.ID ?? "-1" ,date: dateString ,relation: relationId ,occasion :occasionId , compeletion :{
                json in
                if json?.success == 1 {
                    self.stopActivityIndicator()
                    self.finishListner?.onEventAdded()
                    self.addedSuccessfully()
                    DispatchQueue.main.async {
                    self.performSegueToReturnBack()  }
                } else {
                    self.addedFailed(message: "faild to update event, please try again")

                }
            })
        }
        
    }
    
}

protocol EventAdded{
    func onEventAdded()
}
