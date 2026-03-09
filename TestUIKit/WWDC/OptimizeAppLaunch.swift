//
//  OptimizeAppLaunch.swift
//  TestUIKit
//
//  Created by Duck Sern on 17/2/26.
//

import Foundation

/// App launch
/// Why launch is important
/// - First experiece with your app should be delightful
/// - Impacts system performance and battery
///
/// Launch Types
/// - Cold:
///     - After reboot
///     - App is not in memory
///     - No process exists
///     Bring app from disk to memory
/// - Warm
///     - Recently terminated
///     - App is partially in memory
///     - No process exitss
/// - Resume:
///     - App is suspended
///     - App is fullu in memory
///     - Process exists
/// Goal: render first frame: 400ms
/// Phases of App Launch
/// - User tap app icon
/// - OS use 100ms to intianilize app: Runtime init
/// - Developer has 300ms to render placeholder UI: UIKit init, Application init
///
/// System Interface -> Runtime init -> UIKit init -> Application init -> Initial Frame Render -> Extended
///
/// System Interface
/// Dyld3: Dynamic linker loads shared library and frameworks in phase System Interface
/// - Cache of runtime dependencies to improve warm laucnh
/// - Prefer hard linking
/// - Avoid dynamic load during launch
/// App Startup Time: Past, Present and Future WWDC 2017
///
/// libSystem init:
/// - Init low level system components: has fixed cost
///
/// Static Runtime init:
/// - Init language runtime
/// - Invokes all class static load methods => consider lazy load
/// - Expose API to init framework
/// - In Objc, avoid Class load => use Classs initialize
///
/// UIKit init
/// - System init UIApplication, AppDelegate
///
/// Application init: developer control over lifecycle callbacks
/// First Frame Render: init root view controler
/// - Flatten view tree and lazily load views
/// - Optimize layout usage: reduce contraints, ...
///
/// Measure launch time
/// - Setup clean enviroment
///     - Reboot then let system quisce for 2-3 minutes
///     - Enable Airplane Mode or mock the network
///     - Use unchanging or no iCloud Account
///     - Use release build of app
///     - Measure warm launch
///
///  Measure using XCTest: `Improving Battery Life and Performance: WWDC 19`
///  `Mordernizing Grand Central Dispatch Usage: WWDC 17`
///   `High performance Autolayout`
///
///  Profile -> Compile in release mode
///
///
