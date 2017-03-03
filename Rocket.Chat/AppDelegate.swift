//
//  AppDelegate.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/5/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func registerForNotification()
    {
        
//        var action1:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
//        action1.activationMode = UIUserNotificationActivationMode.background
//        action1.title = "Say something"
//        action1.identifier = "inline-reply"
//        action1.behavior = UIUserNotificationActionBehavior.textInput
//        
//        let category:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
//        category.identifier = "INVITE_CATEGORY"
//        
//
//        category.setActions([action1], for: UIUserNotificationActionContext.default)
//        category.setActions([action1], for: UIUserNotificationActionContext.minimal)
//
//        let categories = NSSet(object: category) as! Set<UIUserNotificationCategory>

        let settings = (UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()

    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Launcher().prepareToLaunch(with: launchOptions)

        registerForNotification()

        return true
    }

    // MARK: AppDelegate LifeCycle

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let _ = AuthManager.isAuthenticated() {
            UserManager.setUserPresence(status: .away) { (_) in
                SocketManager.disconnect({ (_, _) in })
            }
        }
//        let localNotification:UILocalNotification = UILocalNotification()
//        localNotification.alertAction = "Testing inline reply notificaions on iOS9"
//        localNotification.alertBody = "Woww it works!!"
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
//        localNotification.category = "INVITE_CATEGORY";
//        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    // MARK: Remote Notification
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Log.debug("Notification: \(notification)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let jsonString = userInfo["ejson"] as? NSString {
            let data = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)
            do{
                let unArchDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                let ridString = unArchDictionary?["rid"] as? NSString
                if let sender = unArchDictionary?["sender"] as? NSDictionary {
                    if let idString = sender["_id"] as? NSString {
                        UserDefaults.standard.set(true, forKey: "notification")
                        UserDefaults.standard.set(ridString, forKey: "ridString")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            catch{
                Log.debug("exception thrown")
            }
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let jsonString = userInfo["ejson"] as? NSString {
            let data = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)
            do{
                let unArchDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                let typeString = unArchDictionary?["type"] as? NSString
                let ridString = unArchDictionary?["rid"] as? NSString
                if let sender = unArchDictionary?["sender"] as? NSDictionary {
                    if let idString = sender["_id"] as? NSString {
                        UserDefaults.standard.set(true, forKey: "notification")
                        UserDefaults.standard.set(ridString, forKey: "ridString")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            catch{
                Log.debug("exception thrown")
            }
        }
    }

//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void)
//    {
//        Log.debug("identifier: \(identifier)")
//
//        if (identifier?.isEqual("inline-reply"))!
//        {
//            Log.debug("userInfo: \(userInfo)")
//            
//            let reply = responseInfo[UIUserNotificationActionResponseTypedTextKey]
//
//            Log.debug("reply: \(reply)")
//
//        }
//    }
//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void)
//    {
//        Log.debug("identifier: \(identifier)")
//        
//        if (identifier?.isEqual("inline-reply"))!
//        {
//            //Log.debug("userInfo: \(userInfo)")
//            
//            //rid of the person whom to text
//            var rid:NSString = ""
//            
//            
//            let reply = responseInfo[UIUserNotificationActionResponseTypedTextKey]
//            
//            let chat: ChatViewController = ChatViewController()
//            let value = chat.canPressRightButton()
//            
//            chat.sendMessageFromBackground(reply as! NSString, rid)
//            if value
//            {
//                Log.debug("reply: \(reply)")
//            }
//        }
//    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken.hexString, forKey: PushManager.kDeviceTokenKey)
//        Log.debug("deviceToken , key: \(deviceToken.hexString, PushManager.kDeviceTokenKey)")

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.debug("Fail to register for notification: \(error)")
    }
}
