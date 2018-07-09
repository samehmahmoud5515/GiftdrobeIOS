//
//  AppDelegate.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/20/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
// #dd5333
// #e9e9e9
/*
 Google Client Id
 1070603122716-3p8ko9mfjedo2srd16mgptfm9kaah508.apps.googleusercontent.com
 */

import UIKit
import SlideMenuControllerSwift
import GoogleSignIn
import Google
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData
import UserNotifications
import OneSignal



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
   
    
var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var storyboard: UIStoryboard
        var initialViewController: UIViewController
      
      
            storyboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "video_vc")
        
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "dda1f4d6-0c98-4892-b51e-83b4b6ef1b48",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
       
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
       FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       GIDSignIn.sharedInstance().clientID = "1070603122716-3p8ko9mfjedo2srd16mgptfm9kaah508.apps.googleusercontent.com"
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTask: UIBackgroundTaskIdentifier = 0
        bgTask = application.beginBackgroundTask(expirationHandler: { application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskInvalid })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /*func applicationDidEnterBackground(_ application: UIApplication) {
     
    }*/

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

 /*   func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
     func application(_ application:UIApplication , open url:URL , options: [UIApplicationOpenURLOptionsKey: Any] ) -> Bool {
        let handelded = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        return handelded
    }*/
   
   func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
}




















