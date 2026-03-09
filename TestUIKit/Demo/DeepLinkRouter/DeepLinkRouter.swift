//
//  DeepLinkRouter.swift
//  TestUIKit
//
//  Created by Duck Sern on 28/2/26.
//

import Foundation

protocol DeepLinkRouter {
    func receiveDeepLink(_ url: URL) -> Bool
    func group(_ path: String, _ config: @escaping (DeepLinkRouter) -> Void)
    func register(_ path: String, _ config: @escaping (URL) -> Bool)
}

final class DeepLinkRouterDefault: DeepLinkRouter {
    var mapGroupRouter: [String: DeepLinkRouter] = [:]
    var mapPath: [String: (URL) -> Bool] = [:]
    
    func receiveDeepLink(_ url: URL) -> Bool {
        // Check group first
        let path = url.absoluteString
        for (groupPath, childRouter) in mapGroupRouter {
            if path.contains(groupPath) {
                return childRouter.receiveDeepLink(url)
            }
        }
        for (path, handler) in mapPath {
            if path.contains(path) {
                return handler(url)
            }
        }
        return false
    }
    
    func group(_ path: String, _ config: @escaping (DeepLinkRouter) -> Void) {
        if mapGroupRouter[path] == nil {
            mapGroupRouter[path] = DeepLinkRouterDefault()
        }
        config(mapGroupRouter[path]!)
    }
    
    func register(_ path: String, _ config: @escaping (URL) -> Bool) {
        mapPath[path] = config
    }
}

final class DemoDeepLinkRouter {
    func appDidReceiveURL() {
        let router = DeepLinkRouterDefault()
        let url: URL = URL(string: "https://www.google.com")!
        router.register("home", { url in
            print("SERN :: go home")
            return true
        })
        router.group("user", { childRouter in
            childRouter.register("signin", { url in
                print("SERN :: go to signin")
                return true
            })
        })
        let isHandled = router.receiveDeepLink(url)
    }
}
