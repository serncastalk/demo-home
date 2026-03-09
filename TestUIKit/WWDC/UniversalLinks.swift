//
//  UniversalLinks.swift
//  TestUIKit
//
//  Created by Duck Sern on 22/2/26.
//

import Foundation

/// http, https link represent your content both on the Web ( when user not install app ) and in your app
/// unique
/// Availabel on iOS, tvOS and macOS
/// App adopt entilements to secure
/// Recommended over custom URL schemes
///
/// Config web server
/// - Install a valid HTTPS certificate
/// - Add your apple-app-site-association file: JSON file, when app is installed, OS download file => know what service server let your app use, OS also periodically download this file
/// => locate at https://example.com/.well-known/apple-app-site-association
/// OS look `components` from top to bottom
/// `exclude`
///
/// Config app
/// - Add Associated Domains
/// - applinks:`link`, when installed OS for apple-file
/// - Internation must be encode as Punny code
/// - Base on NSUserActivity, handle by AppDelegate or SceneDelegate
/// `apllication(continue: , restoreationHandler`:
/// check `activityType == NSUserActivityTypeBrowsingWeb`,
/// get url from `webpageURL`
/// get components = URLComponents(url: url, resolvingAgainstBaseURL: true)
/// - Use Smart App Banner
