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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Launcher().prepareToLaunch(with: launchOptions)

        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        application.registerForRemoteNotifications()

        return true
    }

    // MARK: AppDelegate LifeCycle

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let _ = AuthManager.isAuthenticated() {
            UserManager.setUserPresence(status: .away) { (_) in
                SocketManager.disconnect({ (_, _) in })
            }
        }
    }
 
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1

    }
    // MARK: Remote Notification

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Log.debug("Notification: \(notification)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
        
        Log.debug("Notification: \(userInfo)")
        
        Log.debug("Data: \(userInfo["ejson"])")
        
        if let jsonString = userInfo["ejson"] as? NSString {
            Log.debug("JSON DATA: \(jsonString)")
            
            let data = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)
            
            do{
                let unArchDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                Log.debug("JSON DATA: \(unArchDictionary)")
                
                //let typeString = unArchDictionary?["type"] as? NSString
                
                let ridString = unArchDictionary?["rid"] as? NSString
                
                //let nameString = unArchDictionary?["name"] as? NSString
                
                
                if let sender = unArchDictionary?["sender"] as? NSDictionary {
                    Log.debug("sender: \(sender)")
                    
                    if let idString = sender["_id"] as? NSString {
                        Log.debug("id of sender: \(idString)")
                        
                        
                        UserDefaults.standard.set(true, forKey: "notification")
                        
                        UserDefaults.standard.set(ridString, forKey: "ridString")
                        
                        UserDefaults.standard.synchronize()
                        
                        //ChatViewController.sharedInstance()?.viewDidLoad()
                        
                    }
                }
                
            }
            catch{
                Log.debug("exception thron")
            }
            
        }

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
        
        Log.debug("Data: \(userInfo["ejson"])")
        
        if let jsonString = userInfo["ejson"] as? NSString {
            Log.debug("JSON DATA: \(jsonString)")
            
            let data = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)
            
            do{
                let unArchDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                Log.debug("JSON DATA: \(unArchDictionary)")
                
                let typeString = unArchDictionary?["type"] as? NSString
                
                let ridString = unArchDictionary?["rid"] as? NSString

                //let nameString = unArchDictionary?["name"] as? NSString

                
                if let sender = unArchDictionary?["sender"] as? NSDictionary {
                    Log.debug("sender: \(sender)")
                    
                    if let idString = sender["_id"] as? NSString {
                        Log.debug("id of sender: \(idString)")
                        
                        
                        UserDefaults.standard.set(true, forKey: "notification")
                        
                        UserDefaults.standard.set(ridString, forKey: "ridString")
                        
                        UserDefaults.standard.synchronize()

                        //ChatViewController.sharedInstance()?.viewDidLoad()
                        
                    }
                }

            }
            catch{
                Log.debug("exception thron")
            }

        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken.hexString, forKey: PushManager.kDeviceTokenKey)
//        Log.debug("deviceToken , key: \(deviceToken.hexString, PushManager.kDeviceTokenKey)")

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.debug("Fail to register for notification: \(error)")
    }
}
