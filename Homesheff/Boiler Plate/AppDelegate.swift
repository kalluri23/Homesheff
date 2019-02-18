//
//  AppDelegate.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
      let viewModel = SignInViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       // UINavigationBar.appearance().backgroundColor = UIColor(red: 145.0/255.0, green: 175.0/255.0, blue: 88.0/255.0, alpha: 1.0)
     //   UINavigationBar.appearance().tintColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        ConfigEndPoints.shared.initialize()
        IQKeyboardManager.shared.enable = true
        self.setInitialScreen()
       // IQKeyboardManager.shared().isEnabled = true
        loadFacebook(application: application, options: launchOptions)
        // LocationManager.shared.requestForLocation()
        return true
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
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    /** Check if user is logged in and set the initial content screen
    */
    private func setInitialScreen() {
        //user previously logged in to app
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            
            viewModel.autoSignIn(envelop: viewModel.autoSignInEnvelop(userId:UserDefaults.standard.integer(forKey: "userId") )) { (success) in
                
                if success {
                   self.goToCheffList()
                } else {
                    self.goToSiginView()
                }
            }
        } else { //user does not have a session before
            goToSiginView()
        }
    }
    
    private func goToCheffList() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarControllerId")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func goToSiginView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func loadFacebook(application: UIApplication, options: [AnyHashable : Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: options)
        FBSDKSettings.setAppID("295227917866107")
    }
}

