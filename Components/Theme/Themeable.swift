//
//  Themeable.swift
//  Components
//
//  Created by Sonny on 6/5/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

public protocol Themeable {
    var fonts  : AppFont { get set }
    var colors : AppColor { get set }
    var radius : AppRadius { get set }
}

public protocol AppFont {
    /// Semibold - 60
    var h1UpCase         : UIFont { get }
    
    /// Semibold - 38
    var h2UpCase         : UIFont { get }
    
    /// Bold - 30
    var h3UpCase         : UIFont { get }
    
    /// Bold - 32
    var h3               : UIFont { get }
    
    /// Bold - 28
    var h4               : UIFont { get }
    
    /// Bold - 26
    var h4JP             : UIFont { get }
    
    /// Semibold - 20
    var h5               : UIFont { get }
    
    /// Bold - 18
    var title1B          : UIFont { get }
    
    /// Bold - 16
    var body1B           : UIFont { get }
    
    /// Semibold - 16
    var body1SB          : UIFont { get }
    
    /// Medium - 16
    var body1M           : UIFont { get }
    
    /// Regular - 16
    var body1R           : UIFont { get }
    
    /// Bold - 14
    var body2BUpCase     : UIFont { get }
    
    /// Semibold - 14
    var body2SBUpCase    : UIFont { get }
    
    /// Regular - 14
    var body2RUpCase     : UIFont { get }
    
    /// Semibold - 14
    var body2SB          : UIFont { get }
    
    /// Medium - 14
    var body2M           : UIFont { get }
    
    /// Regular - 14
    var body2R           : UIFont { get }
    
    /// Regular - 12
    var subText1M        : UIFont { get }
    
    /// Semibold - 12
    var subText2SB       : UIFont { get }
    
    /// Medium - 10
    var subText2M        : UIFont { get }
    
    /// Regular - 10
    var subText2R        : UIFont { get }
    
    /// Semibold - 9
    var subText3SBUpCase : UIFont { get }
}

public protocol AppColor {
    /// EE3424
    var primary1      : UIColor { get }
    
    /// F4AA1C
    var primary2      : UIColor { get }
    
    /// FFFFFF
    var white         : UIColor { get }
    
    /// F5F5F5
    var lightGray     : UIColor { get }
    
    /// E6E3E3
    var middleGray    : UIColor { get }
    
    /// D1D1D1
    var inactiveGray1 : UIColor { get }
    
    /// 969696
    var inactiveGray2 : UIColor { get }
    
    /// 2E2E2E
    var darkGray      : UIColor { get }
    
    /// 181818
    var black         : UIColor { get }
    
    /// 28A745
    var success       : UIColor { get }
    
    /// 28A745 10%
    var paleGreen     : UIColor { get }
    
    /// FFD89E
    var paleYellow    : UIColor { get }
    
    /// FFC107
    var warning       : UIColor { get }
    
    /// FFC107 10%
    var paleWarning   : UIColor { get }
    
    /// FF9A8D
    var paleRed       : UIColor { get }
    
    /// FF9A8D 10%
    var paleRed10     : UIColor { get }
    
    /// FCFCFC
    var paleWhite     : UIColor { get }
    
    /// E93E21
    var error         : UIColor { get }
    
    /// CCC769 80%
    var lightYellow   : UIColor { get }
    
    /// FFFFFF 90%
    var white90       : UIColor { get }
    
    /// FFFFFF 80%
    var white80       : UIColor { get }
    
    /// FFFFFF 70%
    var white70       : UIColor { get }
    
    /// FFFFFF 60%
    var white60       : UIColor { get }
    
    /// FFFFFF 50%
    var white50       : UIColor { get }
    
    /// FFFFFF 40%
    var white40       : UIColor { get }
    
    /// FFFFFF 30%
    var white30       : UIColor { get }
    
    /// FFFFFF 20%
    var white20       : UIColor { get }
    
    /// FFFFFF 10%
    var white10       : UIColor { get }
    
    /// 181818 90%
    var black90       : UIColor { get }
    
    /// 181818 80%
    var black80       : UIColor { get }
    
    /// 181818 70%
    var black70       : UIColor { get }
    
    /// 181818 60%
    var black60       : UIColor { get }
    
    /// 181818 50%
    var black50       : UIColor { get }
    
    /// 181818 40%
    var black40       : UIColor { get }
    
    /// 181818 30%
    var black30       : UIColor { get }
    
    /// 181818 20%
    var black20       : UIColor { get }
    
    /// 181818 10%
    var black10       : UIColor { get }
}

public protocol AppRadius {
    /// Small corner radius value   = 4
    var s  : CGFloat { get }
    /// Regular corner radius value = 6
    var m  : CGFloat { get }
    /// Large corner radius value   = 12
    var l  : CGFloat { get }
    /// Large corner radius value   = 14
    var l1 : CGFloat { get }
}

public enum AppFontScale: String {
    case small
    case medium
    case large
    
    public var scale: CGFloat {
        switch self {
        case .small:
            0.75
        case .medium:
            1
        case .large:
            1.25
        }
    }
}
