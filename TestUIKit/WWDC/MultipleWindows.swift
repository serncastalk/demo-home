//
//  MultipleWindows.swift
//  TestUIKit
//
//  Created by Duck Sern on 17/2/26.
//

import Foundation

/// Design intent ( What )
/// Should my app support multiple windows?
/// - Ability to see 2 things together in an app
/// - Drag and drop between windows
///
/// Interaction should create new window ( scene )
/// - Interaction in launch pad and docks is supported by OS
/// - Interaction like drag and drop, master - detail is handled by app
///
/// How to adopt
/// - UIWindowScene
/// - UISceneSession
/// Structure
/// UIScreen -> UIWindowScene -> UIWindow -> UIView
/// UIScene:
/// - Contains UI
/// - Created by OS on demand
/// - Destroyed by OS when unused
/// UISceneSession
/// - Persisted interface state
/// - Have defined system role ( standard, external )
/// - Created for new app
/// - Scene connect, disconnect from session
///
/// - Scene responsible for UI
/// - UIApplication more about process state
///
/// UIScene state restoration
/// - State restoration is now dat in the form of NSUserActivity
/// - Requested from UISceneDelegate ( UIKit request )
/// - Accessible at any time via UISceneSession.stateRestorationActivity
///
///  Set `view.window.windowScene.userActivity` fro state restoration
///
///  UIApplication.shared.reqesetSceneSessionActivitation => Open new window
///  Updated App Switcher Snapshort => UIApplication.shared.requestSceneSessionRefresh
///  Close a window: requesetSceneSessionDestruction ( use `windowDissmissalAnimation` for anim )
///
///  Scenes run concurrently with each other, sharing the same memory and app process space. As a result, a single app may have multiple scenes and scene delegate objects active at the same time.
