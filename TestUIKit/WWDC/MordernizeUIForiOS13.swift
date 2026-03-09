//
//  MordernizeUIForiOS13.swift
//  TestUIKit
//
//  Created by Duck Sern on 21/2/26.
//

import UIKit
/*
 let appearance = UINavigationBarAppearance()
 appearance.configureWithOpaqueBackground()
 // 3 appearance
 navigationBar
 - standardAppearance = appearance
 - compactAppearance
 - scrollEdgeAppearance
 buttonAppearance for left
 doneButtonAppeaance for right item
 UIToolbarAppearance => UIToolbar
 UITabbarAppearance => UITabBar
 - stackedLayoutout
 - inlineLayout => ipad
 - compactInlineLayout
 
 let appearnce = nav.stand.copy()
 navigationItem.standardAppea = appearance => customize nav bar per screen
 
 */

/// Presentation
/// default = UIModalPresentationStyle.automatic => resolve to `pageSheet` when present, depend on presented viewcontroller
/// Apple attach a gesture to support pull to dissmiss even with scrollview
/// Not allow user pull to dismiss
/// - set `isModalInPresentation`
/// - `presentationControllerDidAttemptToDismiss` = UIKit call when user attempt to pull to dismiss
/// only call when `isModalInPresentation` = true
/// - `presentationControllerWillDismiss` => good at get transitionCoordinator to animate
///
/// Appearance Callbacks
/// `FullScreen`
/// - `presentingViewController` is removed from view tree => receive appear lifecycle call back
/// `Page and Form Sheet`
/// - `presentingViewController` not receive appear lifecycle => look at `presentationWillDismiss` callbacks
///
/// UIKit add private view between `UIWindow` and `rootViewController.view` => don't write code assume view tree because UIKit owns it
///
/// Search: `token` , `UISearchToken` of `UISearchTextField`
/// Every char is assign a UITextPosition, relative to .beginningOfDocument
/// textualRange
///
/// `UITextinteraction`
/// - A set of gesture relate to text
/// - Editable and non-editable text interactions
/// - Use `UITextInput` protocal to control selection UI
/// - `textView.addInteraction`
///
/// Multiple selection on Collection and Tabview
/// - `shouldBeginMultipleSectionInteractionAtIndexPath`
/// - `didBeginMultipleSectionInteractionAtIndexPath` => adopt UI when enter multiple selection mode
///
/// UIContextMenuInteraction
/// - Rich previews
/// - Complex ui
///     - nested sub menus
///     - inline sections
/// - Gesture
///    - 3D Touch
///    - Haptic Touch
///    - Long press
///    - Second click
///    - Adopt depend on device
///    - Interaction with drag and drop
///
///  UIMenu and UIAction
///  - Tree menu, composable
///
///  Adopt `UIView.addInteraction` and implement `UIContextMenuInteractionDelegate`
///  UIContextMenuConfiguration
///  `UITargetdPreview` -  `UITargetedDragPreview`
///
///
