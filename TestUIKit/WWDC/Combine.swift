//
//  Combine.swift
//  TestUIKit
//
//  Created by Duck Sern on 16/2/26.
//

import Foundation

/// WWDC 2019
/// - Introduce Combine
/// - Combine in Practice
/// Combine
/// Feature:
/// - Generic
/// - Type safe
/// - Request driven??
///
/// Publisher
/// - Defines how values and erorrs are produced not neccesiraly produce value
/// - Value types ( struct )
/// - Allow registration of a `Subscriber`
///
/// Subscriber
/// - Receives values and a completion
/// - Reference type ( class )
///
/// Subscription
/// - how a subsriber control a flow of data from a publisher to subscriber
///
/// Pattern
/// - Subcriber is attached to Publisher
/// - Publiser sends a Subscription
/// - Subscriber requests N values
/// - Publisher sends N values or less
/// - Publisher sends completion
///
/// Operatior
/// - Adpots Publisher
/// - Subscribes to a Publisher ( upstream )
/// - Sends result to a Subscriber ( downstream)
/// - Value types
///
/// Future: single value async
/// Publisher: many value async
///
/// Error handling
/// - AssetNoFailer: Assume Error = Never
/// - retry
/// - catch: recovery an error by replace error publisher by a new one
/// - mapError
/// - setFailureType
/// When error, subscription is gone
/// - flatMap: pattern to recover error and still receive original upstream not replace it
/// - publisher(for:
///
/// Subscriber
/// - In response to subscribe call, a publiser will call `receive(subscription: )` once
/// - A publiser can provide value after subscriber request them via above step
/// - A publiser can send at most one `receive(completion: )` indicate a complete a failer, after signal => no more connect
///
/// Subject
/// - Behave both like Publisher and Subscriber
/// - Broadcast values to multiple subscribers
/// - `share()` inject passthourgh subject into a stream
///
/// SwiftUI
/// - SwiftUI owns the Subscriber
/// - Just need to provide publisher
/// - `BindableObject` protocol, `@ObjectBinding` => foundation of `@State`, `@StateObject`?
/// @Published adds a publisher to any property
///
/// `eraseToAnyPublisher()` great to hide implementation detail => provide boundary
/// Use `Future` to convert another async API (closure, async await) to combine world
///
///
