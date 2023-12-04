//
//  Parent_SwiftUIApp.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 06.04.2023.
//

import SwiftUI
import OneSignal

@main
struct Parent_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let navigationHelper = NavigationHelper()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(delegate)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    @Published var job = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
            
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("c5655221-84d3-45d7-90c7-9aca0424db78")
        
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notification: \(accepted)")
        })
    
        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
      
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo:->  \(userInfo)")
        let custom = userInfo["custom"] as! NSDictionary
        let notifData = custom["a"] as! NSDictionary
        
        let stdIdx = notifData["user_idx"] as! String
        let stdPhoto = notifData["user_photo"] as! String
        let stdName = notifData["full_name"] as! String
        let stdClass = notifData["std_class"] as! String
        
        job = notifData["job"] as! String
        
        studentIdx = stdIdx
        studentName = stdName
        studentPhoto = stdPhoto
        studentClass = stdClass
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        switch application.applicationState {
//        case .active:
//            //app is currently active, can update badges count here
//            break
//        case .inactive:
//            
//            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
//            break
//        case .background:
//            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
//            break
//        default:
//            break
//        }
//    }
}
