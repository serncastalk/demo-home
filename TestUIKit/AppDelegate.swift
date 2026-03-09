//
//  AppDelegate.swift
//  TestUIKit
//
//  Created by Duck Sern on 31/3/25.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /// Pass nil -> System create background serial queue
        /// Register task handler
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.test.uikit.refresh", using: nil) { task in
            /// Handle refresh
            task.expirationHandler = {
                /// Cancel anything
                task.setTaskCompleted(success: false)
            }
            /// Must call event if task is cancel if not called app will be suspensed -> affect launch performance later
            task.setTaskCompleted(success: true)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.test.uikit.db.clean", using: nil) { task in
            /// Handle refresh
            task.expirationHandler = {
                /// Cancel anything
                task.setTaskCompleted(success: false)
            }
            /// Must call event if task is cancel if not called app will be suspensed -> affect launch performance later
            task.setTaskCompleted(success: true)
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let refreshRequest = BGAppRefreshTaskRequest(identifier: "com.test.uikit.refresh")
        // set minimum time to start
        refreshRequest.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        do {
            try BGTaskScheduler.shared.submit(refreshRequest)
        }
        catch {
            print("Cound not request : \(error)")
        }
        
        let cleanRequest = BGProcessingTaskRequest(identifier: "com.test.uikit.db.clean")
        /// Only wake app when has network
        cleanRequest.requiresNetworkConnectivity = true
        /// Use if request need lots of power, CPU -> set true => disable CPU monitor
        cleanRequest.requiresExternalPower = true
    }

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

