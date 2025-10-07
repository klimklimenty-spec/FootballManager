import Foundation
import UIKit


import SwiftUI
import OneSignalFramework


@main

class AppDelegate: UIResponder, UIApplicationDelegate {
  
    
   static var orientationLock =
   UIInterfaceOrientationMask.all

   func application(_ application: UIApplication,
   supportedInterfaceOrientationsFor window:
   UIWindow?) -> UIInterfaceOrientationMask {
   return AppDelegate.orientationLock
   }
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       OneSignal.initialize("d33faf0c-1f75-4bfb-9629-832e6f45c53c", withLaunchOptions: launchOptions)
       OneSignal.Notifications.requestPermission({ accepted in
           print("User accepted notifications: \(accepted)")
       }, fallbackToSettings: true)

       return true
   }

   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
       return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
 
       
   }

    

   
   

}

