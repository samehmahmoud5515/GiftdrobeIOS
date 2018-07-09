//
//  FirstFilterVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/1/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import DropDown
//import SwiftRangeSlider
import SlideMenuControllerSwift
import SwiftMessages
import TTRangeSlider


class FirstFilterVC: BaseViewController , RadioBtnDelgate {
    
    @IBOutlet weak var newSlider:TTRangeSlider!
    @IBOutlet weak var day_view: UIView!
    @IBOutlet weak var month_view: UIView!
    @IBOutlet weak var day_btn: UIButton!
    @IBOutlet weak var year_btn: UIButton!
    @IBOutlet weak var month_btn: UIButton!
    @IBOutlet weak var year_view: UIView!
    //@IBOutlet weak var range_slider: RangeSlider!
    @IBOutlet weak var relation_iv: UIImageView!
    @IBOutlet weak var ocassion_iv: UIImageView!
    @IBOutlet weak var ocassion_btn: UIButton!
    @IBOutlet weak var relationship_btn: UIButton!
    @IBOutlet var viewModel: FilterViewModel!
    lazy  var selectedOccassionId: String = ""
    lazy var selectedRelationId: String = ""
   
    lazy var selectedDate: String = ""
    var selectedType: String = ""
    var selectedDay: String = ""
    var selectedYear: String = ""
    var selectedMonth : String = ""
    @IBOutlet weak var relationActivityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var occassionActivityIndicator : UIActivityIndicatorView!
    var premiumListener : RefreshPremium?
   
    @IBOutlet weak var for_him_label: UILabel!
    @IBOutlet weak var for_her_label: UILabel!
    @IBOutlet weak var for_her_btn: RadioButton_!
    @IBOutlet weak var for_him_btn: RadioButton_!
    

   
    
    func  onRadioBtnClicked(isChecked: Bool,name: String) {
        if name == "her" && isChecked {
            selectedType = "1"
        }else if name == "him" && isChecked {
            selectedType = "2"
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        newSlider.selectedHandleDiameterMultiplier = 1.0
        newSlider.lineHeight = 2
        newSlider.handleDiameter = CGFloat(32)
       
        
        
        for_her_btn.delegate = self
        for_him_btn.delegate = self
        for_her_btn.name = "her"
        for_him_btn.name = "him"
        for_him_btn.buttonClicked(sender: for_him_btn)

        let for_him_tab = UITapGestureRecognizer(target: self, action: #selector(self.for_him_action))
        let for_him_tab_ = UITapGestureRecognizer(target: self, action: #selector(self.for_him_action))

        for_him_label.addGestureRecognizer(for_him_tab)
        for_him_label.isUserInteractionEnabled = true
        let for_her_tab = UITapGestureRecognizer(target: self, action: #selector(self.for_her_action))
        let for_her_tab_ = UITapGestureRecognizer(target: self, action: #selector(self.for_her_action))
        for_her_label.addGestureRecognizer(for_her_tab)
        for_her_label.isUserInteractionEnabled = true
        for_him_btn.addGestureRecognizer(for_him_tab_)
        for_her_btn.addGestureRecognizer(for_her_tab_)

        occassionActivityIndicator.startAnimating()
        viewModel.requestOcassion(completion: {
            success in
            if success == true {
                
            }
            else {
                
            }
            DispatchQueue.main.async {
                self.occassionActivityIndicator.stopAnimating()
                self.occassionActivityIndicator.isHidden = true
            }
        })
        relationActivityIndicator.startAnimating()
        viewModel.requestRelations(completion: {
            success in
            if success == true {
                
            }else {
                
            }
            DispatchQueue.main.async {
                self.relationActivityIndicator.stopAnimating()
                self.relationActivityIndicator.isHidden = true
            }
        })
    }


    @IBAction func occassion_btn_action(_ sender: Any) {
        if viewModel.getOccassionCount() != 0 {
            ocassion_btn_func()
        }
    }
 
    @IBAction func relationship_btn_action(_ sender: Any) {
        if viewModel.getRelationCount() != 0 {
            relation_btn_func()
        }
    }
    
   
   
    @objc func for_him_action() {
        if for_her_btn.isChecked {
            for_her_btn.buttonClicked(sender: for_her_btn)
        }
        if for_him_btn.isChecked == false {
            for_him_btn.buttonClicked(sender: for_him_btn)
        }
    }
    @objc func for_her_action() {
        if for_him_btn.isChecked {
            for_him_btn.buttonClicked(sender: for_him_btn)
        }
        if for_her_btn.isChecked == false {
            for_her_btn.buttonClicked(sender: for_her_btn)
        }
    }
   
    @objc func ocassion_btn_func()
    {
        let dropDown = DropDown()
        dropDown.anchorView = ocassion_btn
        dropDown.dataSource = viewModel.getOccassionArrString()
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.ocassion_btn.setTitle(item, for: .normal)
            self.selectedOccassionId = self.viewModel.getOccassionId(position: index)
        }
        dropDown.show()
    }
    
     @objc func relation_btn_func()
     {
        let dropDown = DropDown()
        dropDown.anchorView = relationship_btn
        dropDown.dataSource = viewModel.getRelationsArrString()
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.relationship_btn.setTitle(item, for: .normal)
            self.selectedRelationId = self.viewModel.getRelationId(position: index)
        }
        dropDown.show()
     }
    
    @IBAction func ok_btn_action(_ sender: Any) {
        let minVal = newSlider.selectedMinimum
        let maxVal = newSlider.selectedMaximum
        let minValInt = Int(minVal)  ; let maxValInt = Int(maxVal)
        print (String(minValInt))
        print (String(maxValInt))

        if selectedYear == "" || selectedMonth == "" || selectedDay == "" || selectedOccassionId == ""  ||
            selectedRelationId == "" {
            submitFailed()
            return
        }
        self.startActivityIndicator()
        self.selectedDate = selectedYear + "-" + selectedMonth + "-" + selectedDay
        viewModel.submitFiler(age: self.selectedDate, from: String(minValInt) , to: String(minValInt), occasion: selectedOccassionId, relation: selectedRelationId, update_flag: "0", type: selectedType, completion: {
            success in
            DispatchQueue.main.async {
            self.stopActivityIndicator()

                if self.premiumListener != nil {
                    _ = self.navigationController?.popViewController(animated: true)
                    self.premiumListener?.onRefreshPremium()
                    
                } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = RootViewControoler()
            let aObjNavi = UINavigationController(rootViewController: mainViewController)

            let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
            let slideMenuController = SlideMenuController(mainViewController: aObjNavi, leftMenuViewController: leftViewController)
            self.present(slideMenuController, animated: false, completion: nil)
                }
            }
        })
       
    }
    
    @IBAction func send_flowers_btn_action(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FlowersSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Once_or_Scheduled_VC_nav")
        self.present(newViewController, animated: true, completion: nil)
        }
    
    @IBAction func skip_btn_action(_ sender: Any) {
        self.startActivityIndicator()
        self.viewModel.skipFilter(completion: {
            success in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = RootViewControoler()
                    let aObjNavi = UINavigationController(rootViewController: mainViewController)
                    
                    let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                    let slideMenuController = SlideMenuController(mainViewController: aObjNavi, leftMenuViewController: leftViewController)
                    self.present(slideMenuController, animated: false, completion: nil)
                }
            }else {
                self.submitFailed(msg: "Please check internet connection")
            }
            self.stopActivityIndicator()
        })
        
        }
    
   
     @objc func day_view_action()
     {
        let dropDown = DropDown()
        
        dropDown.anchorView = self.day_view
        var days : [String] = []
        for i in 1 ... 30
        {
            days.append(String(i))
        }
        dropDown.dataSource = days
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.day_btn.setTitle(item, for: .normal)
            self.selectedDay = item
        }
        
        dropDown.show()
     }
    @objc func month_view_action()
    {
        let dropDown = DropDown()
        
        dropDown.anchorView = self.month_view
        var days : [String] = []
        for i in 1 ... 12
        {
            days.append(String(i))
        }
        dropDown.dataSource = days
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.month_btn.setTitle(item, for: .normal)
            self.selectedMonth = item
        }
        dropDown.show()
    }
    @objc func year_view_action()
    {
        let dropDown = DropDown()
        dropDown.anchorView = self.year_view
        var days : [String] = []
        for i in 1950 ... 2018
        {
            days.append(String(i))
        }
        var days_ = [String]()
        for arrayIndex in stride(from: days.count - 1, through: 0, by: -1) {
            days_.append(days[arrayIndex])
        }
        dropDown.dataSource = days_
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.year_btn.setTitle(item, for: .normal)
            self.selectedYear = item
        }
        dropDown.show()
    }
    
    
    @IBAction func day_btn_action(_ sender: Any) {
        day_view_action()
    }
    
    @IBAction func year_btn_action(_ sender: Any) {
       year_view_action()
    }
    
    @IBAction func month_btn_action(_ sender: Any) {
       month_view_action()
    }
    
    @IBAction func back_btn_action(_ sender: Any) {
       performSegueToReturnBack()
        premiumListener?.onRefreshPremium()
    }
    
    func submitFailed(msg: String = "Please enter all fields")
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
    
}

protocol RefreshPremium {
    func onRefreshPremium()
}


