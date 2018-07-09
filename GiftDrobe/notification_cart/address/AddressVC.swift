//
//  AddressVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import CoreData
import SwiftMessages
import DropDown
import CountryPicker
import Toast_Swift


class AddressVC: UIViewController ,UITextFieldDelegate  {

    @IBOutlet weak var address_spinner_btn: UIButton!
    @IBOutlet weak var country_tf: UITextField!
    @IBOutlet weak var city_tf: UITextField!
    @IBOutlet weak var area_tf: UITextField!
    @IBOutlet weak var street_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!{
        didSet {
            phone_tf?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
            phone_tf?.cancelButtonTapped()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!


    var address_arr = [Address]()
  
    var listener: SubmitLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest : NSFetchRequest<Address> = Address.fetchRequest()
        
        do {
            address_arr = try PersistanceService.context.fetch(fetchRequest)
            if address_arr.count == 0 {
             
            }
           
            
        } catch {
            print("error : \(error)")
        }
        
        let userManager = UserDataManager()
        
        print ( userManager.getUserPhone())
        phone_tf.text = userManager.getUserPhone()

        phone_tf.delegate = self
        city_tf.delegate = self
        area_tf.delegate = self
        street_tf.delegate = self
        country_tf.delegate = self
        
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        phone_tf.resignFirstResponder()
        self.ok_action()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == city_tf {
            area_tf.becomeFirstResponder()
        } else if textField == area_tf {
            street_tf.becomeFirstResponder()
        } else if textField == street_tf {
            phone_tf.becomeFirstResponder()
        } else if textField == phone_tf {
            textField.becomeFirstResponder()
            self.ok_action()
        }else {
        }
        return true
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField)  {
        switch textField  {
            case city_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 50), animated: true)
            case area_tf:
                 scrollView.setContentOffset(CGPoint(x: 0 , y: 70), animated: true)
            case street_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 90), animated: true)
            case phone_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 200), animated: true)
            case country_tf:
                textField.resignFirstResponder()
                let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
                    self.country_tf.text = country.countryName
                }
                countryController.detailColor = UIColor.red
            
        default:
            textField.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing (_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
    }
    

    @IBAction func address_spinner_btn_action(_ sender: Any) {
        if address_arr.count > 0 {
            var add_name :[String] = []
            for add in address_arr {
                add_name.append(add.name!)
            }
        let dropDown = DropDown()
        dropDown.anchorView = address_spinner_btn
        dropDown.dataSource = add_name
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            DispatchQueue.main.async {
                self.country_tf.text = self.address_arr[index].country
                self.city_tf.text = self.address_arr[index].city
                self.street_tf.text = self.address_arr[index].address
                self.area_tf.text = self.address_arr[index].area
            }
        }
        dropDown.show()
        }
    }
    
    
    @IBAction func ok_btn_action(_ sender: Any) {
        self.ok_action()
    }
    
    func ok_action () {
        guard  let phone = phone_tf.text, phone != "" else {
            self.showError()
            return
        }
        if phone.count < 11 {
            self.showError(msg: "mobile must be 11 digits")
            return
        }
        // save mobile
        let userManager = UserDataManager()
        userManager.savePhone(phone: phone)
        
       
        if country_tf.text == "" || city_tf.text == "" || street_tf.text == "" || area_tf.text == "" {
            self.showError()
        }
        else {
            
            var duplicateAdd = false
            for add in address_arr {
                if add.country == country_tf.text &&  add.city == city_tf.text && add.address == street_tf.text && add.area == area_tf.text {
                    duplicateAdd = true
                }
            }
            if duplicateAdd == false {
                let address = Address(context:PersistanceService.context)
                address.country = country_tf.text
                address.city = city_tf.text
                address.area = area_tf.text
                address.address = street_tf.text
                address.name = "Address " + String(address_arr.count)
                PersistanceService.saveContext()
                
            }
            
            self.performSegueToReturnBackWithNoAnimation()
            listener?.onAddressSubmit(country: country_tf.text!,city: city_tf.text!, area: area_tf.text!, street: street_tf.text!, phone: phone_tf.text! )
        }
    }
    
    @IBAction func cancel_spinner_btn_action(_ sender: Any) {
        self.performSegueToReturnBackWithNoAnimation()
    }
    
   
    func showError(msg: String = "Error, Please enter all fields")
    {
        DispatchQueue.main.async {
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .red
            self.view.makeToast( msg , duration: 3.0, position: .bottom, style: style)
        }
    }

}
