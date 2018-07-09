//
//  ScheduledFlowersVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/22/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import DropDown
import SwiftMessages


class ScheduledFlowersVC: BaseViewController ,radioButtonClickedTableDelegate , UITextFieldDelegate{

    @IBOutlet var api : SchedulingAPI!
    @IBOutlet weak var radioGroup: PVRadioButtonView!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var person_name: UITextField!
    var radioGroupSelectionStr = ""
    var forWhomSelectionStr = ""
    var selectedDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        radioGroup.delegate = self
        radioGroup.addButtons(radioButtonTitles: ["Day","Week","Month","Year"])
        person_name.delegate = self
    }
    func radioButtunClickedInTable(button: PVRadioButton) {
        //print(button.titleLabel?.text ?? "")
        radioGroupSelectionStr = button.titleLabel?.text ?? ""
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func flower_selection_btn_action(_ sender: Any) {
         forWhomSelectionStr = self.person_name.text ?? ""
         if forWhomSelectionStr != "" && radioGroupSelectionStr != "" {
            self.startActivityIndicator()
        //self.greetingMessage = message_tv.text
        let userManager = UserDataManager()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date_picker.date)
            api.setScheduleToApi(message: "", userId: userManager.getUserId(), forWhom: forWhomSelectionStr, repeatPeriod: radioGroupSelectionStr, dateevent: dateString, compeletion: {
                 scheduleId in
                if scheduleId != nil || scheduleId != ""{
                    let userMana = UserDataManager()
                    userMana.saveScheduleId(scheduleId_: scheduleId!)
                    print (userMana.getScheduleId())
                     DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "FlowerContainerVC_nav") as! UINavigationController
                    self.present(newViewController, animated: true, completion: nil)
                    }
                } else {
                    self.showErrorDialog()
                }
                self.stopActivityIndicator()
            })
         } else {
            showErrorDialog()
        }
    }
    
  
    
    func showErrorDialog()
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Missing data", body: "provide data to all fields", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
}
