//
//  AppDelegate.swift
//  shopping-sidekick
//
//  Created by Amritanshu Kajaria on 12/11/16.
//  Copyright © 2016 Amritanshu Kajaria. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            handleShortcut(shortcutItem: shortcutItem)
            return false
        }
        
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        
        
//        // [START register_for_notifications]
//        if #available(iOS 10.0, *) {
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            // For iOS 10 data message (sent via FCM)
//            FIRMessaging.messaging().remoteMessageDelegate = self
//            
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        
//        application.registerForRemoteNotifications()
//        // [END register_for_notifications]
        
        
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)

        return true
    }
    
//      // [START receive_message]
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Unable to register for remote notifications: \(error.localizedDescription)")
//    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs token retrieved: \(deviceToken)")
//        
//        // With swizzling disabled you must set the APNs token here.
//         FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
//    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        FBSDKAppEvents.activateApp()
    }
    
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
//        FIRMessaging.messaging().disconnect()
//        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        FBSDKAppEvents.activateApp()
//    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            // Convert token to string
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print("APNs device token: \(deviceTokenString)")
            updateApnsTokenToDB(deviceToken: deviceTokenString, uid: uid!)

        }
    }
    
    func updateApnsTokenToDB(deviceToken:String, uid:String) {
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let subscribedItems = value?.allKeys as! NSArray
            let userUpdate = "/users/"+uid+"/device_token"
            var childUpdates = [userUpdate:deviceToken]
            for item in subscribedItems{
                let asin =  item as? String
                let itemUpdate = "/items/" + asin! + "/subscribedUsers/" + uid + "/device_token"
                childUpdates[itemUpdate] = deviceToken
            }
            for update in childUpdates{
                ref.child(update.key).setValue(update.value)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void)
    {
        // Handle quick actions
        completionHandler(handleShortcut(shortcutItem: shortcutItem))
    }
    
    enum ShortcutIdentifier: String {
        case addItem
    }
    
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(rawValue: shortcutType) else {
            return false
        }
        
        switch (shortcutIdentifier) {
        case .addItem:
            print("addItem shortcut performed")
            
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "addItemView") as UIViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()

            
//            window!.rootViewController?.present(AddItemViewController(), animated: true, completion: nil)
            return true
        }
        
    }
    
    
}

//
//// [START ios_10_message_handling]
//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//    
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//    }
//}
//// [END ios_10_message_handling]
//
//// [START ios_10_data_message_handling]
//extension AppDelegate : FIRMessagingDelegate {
//    // Receive data message on iOS 10 devices while app is in the foreground.
//    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
//}
//// [END ios_10_data_message_handling]
