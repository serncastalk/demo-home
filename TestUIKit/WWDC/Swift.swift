//
//  Swift.swift
//  TestUIKit
//
//  Created by Duck Sern on 1/3/26.
//

import Foundation

/// ABI and Module stability
///
/// ABI = "Application Binary Interface
/// - Specifies details of a pregram's representation at runtime
/// - Compatible ABIs allows separately compiled code to interact at runtime
/// - Before to integrate from a framework to an app, it is required thiat both need to built with the same compiler
/// => Now app and framework can be built from different compiler
///
/// Module stablity: compile time concept
/// - Swift libraries and the APIS they export are known as modules
/// - Module files are created and used by the compiler
/// - Swift compiler built a manifest (`.swiftmodule` file ) of all APIs in framework that can be used by client
/// - Before required both built using the same compiler
/// - Swift 5.1 introduces a stable and textual module interface file ( `.swiftinterface` file ) provide a stable interface
///
/// Apps use the runtime from OS when it is available
/// Apps that backward deploy contain a runtime copy
/// - Embedded runtime copy is inert on OSs with shared runtime
/// - iOS App Store thins out runtime copy when downloading to iOS 12.2 or later
///
/// String
/// - UTF-8 from Swift 5
/// Language server protocol
/// - Custom `ExpressibleByStringInterpolation` protocol
///
/// Limitation of returning a Protocol Type ( any P )
/// - Loses type identity
/// - Does not compose well with the generics system:
///     - Compare equality
///     - Returned type cannot have any associated types
///     - Returned type cannot have requirements that involve Self
/// - Disables optimizations
///
/// Opaque return types: hide concrete type from client
/// - Compiler enfores that the same type is returned from the implementation
///
/// Property wrapper:
/// - Solve duplicate code in getter and setter of a property
///
/// - Embbed DSL in swift live @ViewBuilder in Swift
///
/// 
