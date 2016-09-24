//
//  AppDelegate.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 21.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window         : UIWindow?
    var navController  : UINavigationController?
    var mainVC         : ObjectsViewController?
    var server         : Server!
    let baseURL        : String! = "http://195.93.229.66:4242"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // urls
        let urls = Urls(url: baseURL)
        
        // server
        server = Server(urls_: urls, requestTimeout: 30)
        server.setAToken(UID)
     
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // DB modul
        let config = Realm.Configuration()
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        
        let odbs = ObjectsDBService(realm: realm)
        let ons = ObjectsNetworkService(server: server, objectDB: odbs)
        let oFacade = ObjectsFacade(objectsNs: ons, objectDB: odbs)
        
        let mainVC = ObjectsViewController(objectFacade: oFacade)
        navController = UINavigationController(rootViewController: mainVC)
        
        window!.rootViewController = navController
        
        window!.backgroundColor = UIColor.grayColor()
        
        window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

