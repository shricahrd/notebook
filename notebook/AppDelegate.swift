//  AppDelegate.swift
//  notebook
//  Created by Abdorahman Youssef on 1/25/19.
//  Copyright © 2019 clueapps. All rights reserved.

import UIKit
import IQKeyboardManager
import Firebase
import AVFoundation
import FirebaseDynamicLinks
import FirebaseMessaging
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalStore.save(appVersion: "1.6")
        LocalStore.save(platform: "ios")
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        registerForRemoteNotification(with: application)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        return true
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("no url")
            return
        }
        print("new URL IS \(url.absoluteString)")
        var bookurl = url.absoluteString
        
        let wordToRemove = "http://admin.notebooklib.com/"
        if let range = bookurl.range(of: wordToRemove) {
            bookurl.removeSubrange(range)
        }

        let bookID = bookurl
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        if let bookDetailsVC = storyboard.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            let bookIdString = bookID
            bookDetailsVC.bookId = bookIdString
            bookDetailsVC.fromAppDelegate = true
            self.window?.rootViewController = bookDetailsVC
        }
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    print("error url", error?.localizedDescription)
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print(url)
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let host = urlComponents?.host ?? ""
        
        print(host)
        
        if host == "secretPage" {
            let sb = UIStoryboard(name: "Main", bundle: .main)
            window?.rootViewController = sb.instantiateInitialViewController()
        }
        
        return true
    }
    
    func registerForRemoteNotification(with application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
//        let dataDict:[String: String] = ["token": fcmToken]
        LocalStore.save(fcmToken: fcmToken)
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("****** fail to register for remote notification ******\n \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
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
