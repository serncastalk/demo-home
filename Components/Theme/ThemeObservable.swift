//
//  ThemeObservable.swift
//  Components
//
//  Created by Duck Sern on 26/1/26.
//  Copyright © 2026 Torilab. All rights reserved.
//

import UIKit

public protocol ThemeObservable: AnyObject {
    func themeDidUpdated()
}

public extension ThemeObservable where Self: UIViewController {
    func themeDidUpdated() {
        defaultThemeDidUpdated()
    }
    
    func defaultThemeDidUpdated() {
        children.compactMap { $0 as? ThemeObservable }
            .forEach {
                $0.themeDidUpdated()
            }
        if let view = view as? ThemeObservable {
            view.themeDidUpdated()
        } else {
            view.subviews.compactMap { $0 as? ThemeObservable }
                .forEach {
                    $0.themeDidUpdated()
                }
        }
    }
}

public extension ThemeObservable where Self: UIView {
    func themeDidUpdated() {
        subviews.compactMap { $0 as? ThemeObservable }
            .forEach {
                $0.themeDidUpdated()
            }
    }
}
