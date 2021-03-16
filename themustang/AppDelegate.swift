//
//  AppDelegate.swift
//  themustang
//
//  Created by Ashik Chalise on 8/22/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit
import MMDrawerController
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var centerContainer : MMDrawerController?


     func initializeDrawer(_ mainStoryboard: UIStoryboard) {
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as!
        HomeController
        let LeftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideBarController") as!
        LeftSideBarController
        let centerView = UINavigationController(rootViewController: homeViewController)
        let leftView = UINavigationController(rootViewController: LeftViewController)
        centerContainer =  MMDrawerController(center: centerView, leftDrawerViewController: leftView)
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView;
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let userLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (userLoggedIn){
             let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            initializeDrawer(mainStoryboard)
        }

        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM

         } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            
        }
        Messaging.messaging().delegate = self
         application.registerForRemoteNotifications()
        
    

        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        return true

    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let defaults = UserDefaults.standard
        defaults.set(fcmToken, forKey: "device_token")

    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])

    }

    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

