//
//  AppDelegate.swift
//  myAlarm
//
//  Created by DevMountain on 8/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
//Register for local notifications when the app launches.
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        AlarmController.shared.alarms = AlarmController.shared.loadFromPersisentStore()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (accepted, error) in
            if let error = error {
                print("Error requesting for notifications:\(error)")
            }
            if !accepted{
                print("Notification access has been denied")
            }
        }
        
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            //do not schedule notifications if not authorized
//            guard settings.authorizationStatus == .authorized else  {  return  }
//            if settings.alertSetting == .enabled {
//                //schedule an alert-only notification
//                self.myScheduledAlertNotification()
//            } else {
//                //schdule
//            }
//        }
        

        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }

}

