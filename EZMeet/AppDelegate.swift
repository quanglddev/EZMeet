//
//  AppDelegate.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import Firebase
import FirebaseUI
import FBSDKCoreKit
import GoogleSignIn
import GooglePlaces
import IQKeyboardManagerSwift
import Armchair

let apiKey = "API_KEY_WITH_PLACES_AND_MAP_SDK_ENABLED"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        FirebaseApp.configure()
        
        setupGoogleSignIn()
        
        GMSPlacesClient.provideAPIKey(apiKey)
//        GMSServices.provideAPIKey(apiKey)
        
        if let location = userDefaults.string(forKey: defaultsKeys.userHomeLocationInString), !location.isEmpty {
            print(location)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as? UINavigationController {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentController = currentController.presentedViewController {
                    currentController = presentController
                }
                   currentController.present(vc, animated: true, completion: nil)
               }
            }
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainVC")
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//            UIApplication.shared.windows.first?.rootViewController?.present(initialViewController, animated: false, completion: nil)

        }
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        deepLinkCheck(url: url)
        
        let handled = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        GIDSignIn.sharedInstance().handle(url)
        
        return handled
    }
    
    
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
//        print("Hellodsfafffdfasdafasffsd")
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

