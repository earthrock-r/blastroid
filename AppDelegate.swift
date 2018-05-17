//
//  AppDelegate.swift
//  Blastroid
//
//  Created by Ranjith R D on 04/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.isStatusBarHidden = true
        customizePopup()
        getDataFromUserDefaults()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            Game.name = (UserDefaults.standard.string(forKey: "name") ?? UIDevice.current.name)
            UserDefaults.standard.removeObject(forKey: "highestScore")
//            self.window?.rootViewController = gameVC
//            self.window?.rootViewController = startVC
            self.window?.rootViewController = goToGameVC
        } else {
            self.window?.rootViewController = startVC
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if window?.rootViewController == GameViewController() {
            gameVC.gscene.pause()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if window?.rootViewController == GameViewController() {
            gameVC.gscene.pause()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if window?.rootViewController == GameViewController() {
            gameVC.gscene.continueGame()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if window?.rootViewController == GameViewController() {
            gameVC.gscene.continueGame()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

}
