//
//  TestSwiftCompiler.swift
//  TestUIKit
//
//  Created by Duck Sern on 26/6/25.
//

import Foundation


func hello(x: Hell) {}

func hi() {
    hello(x: .icNige)
}

struct Hell {
    
}

extension Hell {
    static var icNige: Hell {
        return .init()
    }
}
