//
//  MapViewController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftMessages



class MapViewController: UIViewController ,CLLocationManagerDelegate {

    
    let locationManager: CLLocationManager = CLLocationManager()
   //MKMapView
    @IBOutlet weak var map: MKMapView!
    @IBOutlet var api : CartAPI!
    var listener: SubmitLocation?
    var lat : String = ""
    var long : String = ""
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        /*for location in locations {
            print ("\(index): \(location)")
        }*/
        let location_ = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location_.coordinate.latitude  , location_.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.map.setRegion(region,animated: true)
        self.map.showsUserLocation = true
        print ("lat \(location_.coordinate.latitude) , long \(location_.coordinate.longitude)")
        self.lat = String (location_.coordinate.latitude)
        self.long = String (location_.coordinate.longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        locationManager.stopUpdatingLocation()

    }
    
    @IBAction func submit_btn_action(_ sender: Any) {
        if lat != "" && long != "" {
          
            let alert = UIAlertController(title: "Mobile number", message: "Is this your mobile number?", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "012"
                textField.keyboardType = UIKeyboardType.phonePad
                let usermanger = UserDataManager()
                textField.text = usermanger.getUserPhone()
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let mobile = textField?.text ?? ""
                if mobile == "" {
                    self.showErrorMessage(message: "Enter your mobile")
                    return
                }else if  mobile.count < 11 {
                    self.showErrorMessage(message: "mobile number must be 11 digits")
                    return
                }
                else {
                    let userManager = UserDataManager()
                    userManager.savePhone(phone: mobile)
                    self.locationManager.stopUpdatingLocation()
                    self.performSegueToReturnBack()
                    self.listener?.onLoactionSubmit(lat: self.lat ,long: self.long,phone: mobile)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [ ] (_) in }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            showErrorMessage(message: "cannot get your location try again later or enter your address manually")
        }
    }

    @IBAction func cancel_btn_action(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        self.performSegueToReturnBack()
    }
    func showErrorMessage(message: String)
    {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: message, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
}

protocol SubmitLocation {
    func onLoactionSubmit(lat: String, long: String, phone: String)
    func onAddressSubmit(country: String ,city: String , area: String , street: String, phone : String)
}

