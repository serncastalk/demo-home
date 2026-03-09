//
//  DarkMode.swift
//  TestUIKit
//
//  Created by Duck Sern on 18/2/26.
//

import UIKit

/// Use semantic colors => dynamic color
///
/// Use vibrancy effect: let background material passthrough
/// Create `UIVisualEffectView` with `UIVibrancyEffect` and add to `contentView` of `UIVisualEffectView + UIBlurEffect`
///
/// Base level when view fills entire screen - Elevate level when presenting model, vc
/// Different level => Dirrent color
///
/// UITraitCollection => `UITraitCollection.current` to get current value
///
/// Trait change before these methods
/// - `UIView.layoutSubview`
/// - `UIViewController.viewWillLayoutSubviews`
/// - `UIPresentationController.containerWillLayoutSubviews`
///
/// Integrate with Core animation
/// - traitCollection.performAsCurrent
/// Use `hasDifferentColorAppearance` in `traitCollectionDidChange` to know if theme is changed
///
/// When UIView is created, UIKit predicted traits
/// => `traitCollectionDidChange` called only for changes
/// => `-UITraitCollectionChangeLogginEnabled YES`
///
/// `overrideUserInterfaceStyle` => override trait for all child
/// Set Info.plist key `UIUserInterfaceStyle` to force all app
/// `overrideTraitCollection` to override any traits
///
/// Set foreground color for attribute string

let dynamicColor = UIColor { trait in
    if trait.userInterfaceStyle == .dark {
        return .black
    } else {
        return .white
    }
}
