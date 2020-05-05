//
//  AppDelegate.swift
//  HDProject
//
//  Created by Hieu Dinh on 11/3/19.
//  Copyright © 2019 Hieu Dinh. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        HDUtilities.isPod = false
        FirebaseApp.configure()
        
        let rootViewController = window?.rootViewController
        let viewDidLoadClosure: () -> () = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                guard let self = self else { return }
                
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
            }
        }
        window?.rootViewController = LaunchScreenViewController
            .instantiate(icon: "icon",
                         titleString: "HIEUDINH",
                         viewDidLoadClosure: viewDidLoadClosure)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        HDPasscodeView.showIfNeeded()
    }
}
