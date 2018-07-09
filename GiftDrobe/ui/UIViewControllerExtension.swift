//
//  UIViewControllerExtension.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: nil)
            nav.dismiss(animated: false, completion: nil)
        } else {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)

        }
    }
    
    func performSegueToReturnBackWithNoAnimation() {
        if let nav = self.navigationController {
           
            nav.dismiss(animated: false, completion: nil)
        } else {
          
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    @IBAction func cart_btn_action_(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CartVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func notification_btn_action_(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Notification_Cart_SB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationVC_nav")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func back_btn_action_(_ sender: Any) {
        performSegueToReturnBack()
    }
    
   
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
