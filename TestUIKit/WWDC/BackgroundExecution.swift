//
//  BackgroundExecution.swift
//  TestUIKit
//
//  Created by Duck Sern on 15/2/26.
//

import UIKit
import BackgroundTasks

class BackgroundExecutionTest {
    /// https://developer.apple.com/videos/play/wwdc2019/707/
    func backgroundTask() {
        /// Just need to start a task
        let identifier = UIApplication.shared.beginBackgroundTask {
            print("SERN task expired")
        }
        UIApplication.shared.endBackgroundTask(identifier)
        /*
        ProcessInfo.processInfo.performExpiringActivity(withReason: <#T##String#>, using: <#T##(Bool) -> Void#>)*/
        
        
        /// Background push
        /// Tell device new data is available without alerting user
        /// "content-availabel: 1" without "alert", "sound" or "badge"
        /// System decide when to launch app to download content
        /// Must ste apns-priority = 5 or app will not launch
        /// Shoud set apns-push-type = background ( required for watchOS, recommended for other platform
        ///
        ///
        /// Discretionary Background URL Sesson
        /// Usecase:
        /// - Content does not need to have instantly when app in foreground
        /// Can by download later
        /// - Batch upload ( analytics )
        /// System defer the download untile a better time
        /// Provide information to system for smarter scheduling
        let backgroundConfig = URLSessionConfiguration.background(withIdentifier: "com.test.uikit.upload.background")
        backgroundConfig.isDiscretionary = true
        let session = URLSession(configuration: backgroundConfig)
        
        /// Background Processing Tasks: Several minutes of runtime at system-friendly times
        /// - Deferrable matenance work ( clean up )
        /// - Core ML training/ inference
        /// Can turn off CPU Monitor ( kill process if it takes too much CPU cycle in background -> protect battery life ) for intensive work
        /// Eligible if reqeusted in foreground or if app has been recently used
        ///
        /// Background App Refresh Task
        /// - Have 30 seconds of runtime
        /// Keep app up-to-date throughout the day
        /// System decide when to run task
        ///
        /// Task can submit from extension
        ///  Task is submitted to `BGTaskScheduler`
        let scheduler = BGTaskScheduler.shared
        /// Scheduler will wake main app ( even if task was submitted from extension and deliver task ( maybe multiple tasks is passed )
        /// Run time is limit per app launch, not per request -> concurrent handle request
        /// App must set task completed -> Then app is suspended
        /// Setup
        /// 1. Add capability `background modes` in app target
        /// 2. Add Permitted background task scheduler identifer in `Info.plist`
        /// Each string is unique within app -> recommend use reverse dns to avoid conflict with 3rd party
        ///
        /// How to test:
        /// Let app in background
        /// Pause app
        /// Send command to debug server, simulator
        ///
        /// Ensure files are accessible while device is locked
        /// - FileProtectionType.completeUntilFirstUserAuthentication
        /// UIScene apps should call UIApplecation.requestSceneSessionRefresh
    }
}
