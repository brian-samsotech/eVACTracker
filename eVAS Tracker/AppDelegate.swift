//
//  AppDelegate.swift
//  eVAS Tracker
//
//  Created by Brian on 10/3/21.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SVProgressHUD.setDefaultMaskType(.black)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        if (UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) != nil)
           {
         self.showDashboardScreen()
           
           }
          else{
            self.showLoginScreen()
           }
        return true
    }

    func showLoginScreen() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

         var navigationController = UINavigationController()
         navigationController = UINavigationController(rootViewController: loginViewController)

         //It removes all view controllers from the navigation controller then sets the new root view controller and it pops.
         window?.rootViewController = navigationController

         //Navigation bar is hidden
         navigationController.isNavigationBarHidden = true
    }

    func showDashboardScreen() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       
        let dashboardViewController: MyTabBarController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController") as! MyTabBarController
       
         var navigationController = UINavigationController()
         navigationController = UINavigationController(rootViewController: dashboardViewController)

         //It removes all view controllers from the navigation controller then sets the new root view controller and it pops.
         window?.rootViewController = navigationController

         //Navigation bar is hidden
         navigationController.isNavigationBarHidden = true
     }



}

