//
//  DefaultTheme.swift
//  Components
//
//  Created by Sonny on 12/3/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

struct DefaultJPFont: AppFont {
    init(scale: CGFloat, minFontSize: CGFloat = 10) {
        self.h1UpCase = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 60 * scale))
        self.h2UpCase = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 38 * scale))
        self.h3UpCase = CustomFont.NotoSans.bold.font(with: max(minFontSize, 30 * scale))
        self.h3 = CustomFont.NotoSans.bold.font(with: max(minFontSize, 32 * scale))
        self.h4 = CustomFont.NotoSans.bold.font(with: max(minFontSize, 28 * scale))
        self.h4JP = CustomFont.NotoSans.bold.font(with: max(minFontSize, 26 * scale))
        self.h5 = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 20 * scale))
        self.title1B = CustomFont.NotoSans.bold.font(with: max(minFontSize, 18 * scale))
        self.body1B = CustomFont.NotoSans.bold.font(with: max(minFontSize, 16 * scale))
        self.body1SB = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 16 * scale))
        self.body1M = CustomFont.NotoSans.medium.font(with: max(minFontSize, 16 * scale))
        self.body1R = CustomFont.NotoSans.regular.font(with: max(minFontSize, 16 * scale))
        self.body2BUpCase = CustomFont.NotoSans.bold.font(with: max(minFontSize, 14 * scale))
        self.body2SBUpCase = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 14 * scale))
        self.body2RUpCase = CustomFont.NotoSans.regular.font(with: max(minFontSize, 14 * scale))
        self.body2SB = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 14 * scale))
        self.body2M = CustomFont.NotoSans.medium.font(with: max(minFontSize, 14 * scale))
        self.body2R = CustomFont.NotoSans.regular.font(with: max(minFontSize, 14 * scale))
        self.subText2R = CustomFont.NotoSans.regular.font(with: max(minFontSize, 10 * scale))
        self.subText1M = CustomFont.NotoSans.medium.font(with: max(minFontSize, 12 * scale))
        self.subText2SB = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 12 * scale))
        self.subText2M = CustomFont.NotoSans.medium.font(with: max(minFontSize, 10 * scale))
        self.subText3SBUpCase = CustomFont.NotoSans.semibold.font(with: max(minFontSize, 9 * scale))
    }
    
    let h1UpCase: UIFont
    let h2UpCase: UIFont
    let h3UpCase: UIFont
    let h3: UIFont
    let h4: UIFont
    let h4JP: UIFont
    let h5: UIFont
    let title1B: UIFont
    let body1B: UIFont
    let body1SB: UIFont
    let body1M: UIFont
    let body1R: UIFont
    let body2BUpCase: UIFont
    let body2SBUpCase: UIFont
    let body2RUpCase: UIFont
    let body2SB: UIFont
    let body2M: UIFont
    let body2R: UIFont
    let subText2R: UIFont
    let subText1M: UIFont
    let subText2SB: UIFont
    let subText2M: UIFont
    let subText3SBUpCase: UIFont
}

struct DefaultNonJPFont: AppFont {
    init(scale: CGFloat, minFontSize: CGFloat = 10) {
        self.h1UpCase = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 60 * scale))
        self.h2UpCase = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 38 * scale))
        self.h3UpCase = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 30 * scale))
        self.h3 = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 32 * scale))
        self.h4 = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 28 * scale))
        self.h4JP = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 26 * scale))
        self.h5 = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 20 * scale))
        self.title1B = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 18 * scale))
        self.body1B = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 16 * scale))
        self.body1SB = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 16 * scale))
        self.body1M = CustomFont.FixelDisplay.medium.font(with: max(minFontSize, 16 * scale))
        self.body1R = CustomFont.FixelDisplay.regular.font(with: max(minFontSize, 16 * scale))
        self.body2BUpCase = CustomFont.FixelDisplay.bold.font(with: max(minFontSize, 14 * scale))
        self.body2SBUpCase = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 14 * scale))
        self.body2RUpCase = CustomFont.FixelDisplay.regular.font(with: max(minFontSize, 14 * scale))
        self.body2SB = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 14 * scale))
        self.body2M = CustomFont.FixelDisplay.medium.font(with: max(minFontSize, 14 * scale))
        self.body2R = CustomFont.FixelDisplay.regular.font(with: max(minFontSize, 14 * scale))
        self.subText1M = CustomFont.FixelDisplay.medium.font(with: max(minFontSize, 12 * scale))
        self.subText2R = CustomFont.FixelDisplay.regular.font(with: max(minFontSize, 10 * scale))
        self.subText2SB = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 12 * scale))
        self.subText2M = CustomFont.FixelDisplay.medium.font(with: max(minFontSize, 10 * scale))
        self.subText3SBUpCase = CustomFont.FixelDisplay.semibold.font(with: max(minFontSize, 9 * scale))
    }
    
    let h1UpCase: UIFont
    let h2UpCase: UIFont
    let h3UpCase: UIFont
    let h3: UIFont
    let h4: UIFont
    let h4JP: UIFont
    let h5: UIFont
    let title1B: UIFont
    let body1B: UIFont
    let body1SB: UIFont
    let body1M: UIFont
    let body1R: UIFont
    let body2BUpCase: UIFont
    let body2SBUpCase: UIFont
    let body2RUpCase: UIFont
    let body2SB: UIFont
    let body2M: UIFont
    let body2R: UIFont
    let subText2R: UIFont
    let subText1M: UIFont
    let subText2SB: UIFont
    let subText2M: UIFont
    let subText3SBUpCase: UIFont
}

fileprivate enum CustomFont {
    enum NotoSans {
        case bold
        case semibold
        case medium
        case regular
        
        func font(with size: CGFloat) -> UIFont {
            switch self {
            case .bold:
                UIFont(name: "NotoSansJP-Bold", size: size)
                ?? .systemFont(ofSize: size, weight: .bold)
            case .semibold:
                UIFont(name: "NotoSansJP-SemiBold", size: size)
                ?? .systemFont(ofSize: size, weight: .semibold)
            case .medium:
                UIFont(name: "NotoSansJP-Medium", size: size)
                ?? .systemFont(ofSize: size, weight: .medium)
            case .regular:
                UIFont(name: "NotoSansJP-Regular", size: size)
                ?? .systemFont(ofSize: size, weight: .regular)
            }
        }
    }
    
    enum FixelDisplay {
        case bold
        case semibold
        case medium
        case regular
        
        func font(with size: CGFloat) -> UIFont {
            switch self {
            case .bold:
                UIFont(name: "FixelDisplay-Bold", size: size)
                ?? .systemFont(ofSize: size, weight: .bold)
            case .semibold:
                UIFont(name: "FixelDisplay-SemiBold", size: size)
                ?? .systemFont(ofSize: size, weight: .semibold)
            case .medium:
                UIFont(name: "FixelDisplay-Medium", size: size)
                ?? .systemFont(ofSize: size, weight: .medium)
            case .regular:
                UIFont(name: "FixelDisplay-Regular", size: size)
                ?? .systemFont(ofSize: size, weight: .regular)
            }
        }
    }
}

struct DefaultAppColor: AppColor {
    var primary1: UIColor { .init(hexString: "#EE3424") }
    
    var primary2: UIColor { .init(hexString: "#F4AA1C") }
    
    var white: UIColor { .init(hexString: "#FFFFFF") }
    
    var lightGray: UIColor { .init(hexString: "#F5F5F5") }
    
    var middleGray: UIColor { .init(hexString: "#E6E3E3") }
    
    var inactiveGray1: UIColor { .init(hexString: "#D1D1D1") }
    
    var inactiveGray2: UIColor { .init(hexString: "#969696") }
    
    var darkGray: UIColor { .init(hexString: "#2E2E2E") }
    
    var black: UIColor { .init(hexString: "#181818") }
    
    var success: UIColor { .init(hexString: "#28A745") }
    
    var paleGreen: UIColor { .init(hexString: "#28A745").withAlphaComponent(0.1) }
    
    var paleYellow: UIColor { .init(hexString: "#FFD89E") }
    
    var warning: UIColor { .init(hexString: "#FFC107") }
    
    var paleWarning: UIColor { .init(hexString: "#FFC107").withAlphaComponent(0.1) }
    
    var paleRed: UIColor { .init(hexString: "#FF9A8D") }
    
    var paleRed10: UIColor { .init(hexString: "#E93E21").withAlphaComponent(0.1) }
    
    var paleWhite: UIColor { .init(hexString: "#FCFCFC") }
    
    var error: UIColor { .init(hexString: "#E93E21") }
    
    var lightYellow: UIColor { .init(hexString: "#CCC769").withAlphaComponent(0.8) }
    
    var white90: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.9) }
    
    var white80: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.8) }
    
    var white70: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.7) }
    
    var white60: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.6) }
    
    var white50: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.5) }
    
    var white40: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.4) }
    
    var white30: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.3) }
    
    var white20: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.2) }
    
    var white10: UIColor { .init(hexString: "#FFFFFF").withAlphaComponent(0.1) }
    
    var black90: UIColor { .init(hexString: "#181818").withAlphaComponent(0.9) }
    
    var black80: UIColor { .init(hexString: "#181818").withAlphaComponent(0.8) }
    
    var black70: UIColor { .init(hexString: "#181818").withAlphaComponent(0.7) }
    
    var black60: UIColor { .init(hexString: "#181818").withAlphaComponent(0.6) }
    
    var black50: UIColor { .init(hexString: "#181818").withAlphaComponent(0.5) }
    
    var black40: UIColor { .init(hexString: "#181818").withAlphaComponent(0.4) }
    
    var black30: UIColor { .init(hexString: "#181818").withAlphaComponent(0.3) }
    
    var black20: UIColor { .init(hexString: "#181818").withAlphaComponent(0.2) }
    
    var black10: UIColor { .init(hexString: "#181818").withAlphaComponent(0.1) }
}

struct DefaultRadius: AppRadius {
    var s: CGFloat {
        4.0
    }
    var m: CGFloat {
        6.0
    }
    var l: CGFloat {
        12.0
    }
    var l1: CGFloat {
        14.0
    }
}

public extension UIFont {
    static func appFont(_ keyPath: KeyPath<AppFont, UIFont>) -> UIFont {
        Theme.current.fonts[keyPath: keyPath]
    }
    
    /// Get the font of a specific language. Use case is: from AvatarDetail -> Call | Chat -> Shareable link bubbles
    /// - Parameters:
    ///   - keyPath: keyPath of any fonts that conforms to `AppFont` protocol
    ///   - language: the supported language, which is `ja` or `other`
    /// - Returns: a font object with a specific family and size
    static func appFont(_ keyPath: KeyPath<AppFont, UIFont>, language: ComponentLanguage) -> UIFont {
        language == .ja
        ? DefaultJPFont(scale: Theme.fontScale.scale)[keyPath: keyPath]
        : DefaultNonJPFont(scale: Theme.fontScale.scale)[keyPath: keyPath]
    }
    
    /// Get the font of a specific language. Use case is: from AvatarDetail -> Call | Chat -> Shareable link bubbles
    /// - Parameters:
    ///   - keyPath: keyPath of any fonts that conforms to `AppFont` protocol
    ///   - fontScale: fontScale
    /// - Returns: a font object with a specific family and size
    static func appFont(_ keyPath: KeyPath<AppFont, UIFont>, fontScale: AppFontScale) -> UIFont {
        Theme.language == .ja
        ? DefaultJPFont(scale: fontScale.scale)[keyPath: keyPath]
        : DefaultNonJPFont(scale: fontScale.scale)[keyPath: keyPath]
    }
    
    /// Get the font of medium font scale
    /// - Parameters:
    ///   - keyPath: keyPath of any fonts that conforms to `AppFont` protocol
    /// - Returns: a font object with a specific family and size
    static func staticAppFont(_ keyPath: KeyPath<AppFont, UIFont>) -> UIFont {
        guard Theme.fontScale != .medium else {
            return .appFont(keyPath)
        }
        return Theme.language == .ja
        ? DefaultJPFont(scale: AppFontScale.medium.scale)[keyPath: keyPath]
        : DefaultNonJPFont(scale: AppFontScale.medium.scale)[keyPath: keyPath]
    }
}

public extension UIColor {
    static func appColor(_ keyPath: KeyPath<AppColor, UIColor>) -> UIColor {
        Theme.current.colors[keyPath: keyPath]
    }
}

public extension CGFloat {
    static func appRadius(_ keyPath: KeyPath<AppRadius, CGFloat>) -> CGFloat {
        Theme.current.radius[keyPath: keyPath]
    }
}
