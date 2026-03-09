//
//  Theme.swift
//  Components
//
//  Created by Sonny on 12/3/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

/// A namespace for caller site
public enum Theme {
    public static var colors: AppColor {
        Theme.current.colors
    }
    public static var fonts: AppFont {
        Theme.current.fonts
    }
    public static var radius: AppRadius {
        Theme.current.radius
    }
    
    public static weak var themeObservable: ThemeObservable?
    
    private(set) static var current: Themeable = DefaultTheme()
    
    private(set) static var language: ComponentLanguage = .ja
    private(set) public static var fontScale: AppFontScale = .medium
    
    /// Set a specific language for each getter font method.
    ///
    /// This will produce global effect for:
    /// - any `.appFont(\...)`
    /// - any `Theme.fonts...`
    ///
    /// - Parameter language: the supported language, which is `ja` or `other`
    public static func configureLanguage(_ language: ComponentLanguage) {
        Self.language = language
        configureTheme()
    }
    
    /// Set a font scale
    ///
    /// This will produce global effect for:
    /// - any `.appFont(\...)`
    /// - any `Theme.fonts...`
    ///
    /// - Parameter fontScale: the supported font scale
    public static func configureFontScale(_ fontScale: AppFontScale) {
        Self.fontScale = fontScale
        configureTheme()
    }
    
    private static func configureTheme() {
        let scale = fontScale.scale
        current = DefaultTheme(fonts: language == .ja ? DefaultJPFont(scale: scale) : DefaultNonJPFont(scale: scale),
                               colors: DefaultAppColor(),
                               radius: DefaultRadius())
        themeObservable?.themeDidUpdated()
    }
    
    /// Load all custom fonts from Components Bundle into `.process`
    public static func loadFonts() {
        let fonts = Bundle(for: DefaultTheme.self)
            .urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
    }
}

/// Use this enum for font only at this moment as JA and Other have separate font families
/// - JA: NotoSans
/// - Others: FixedDisplay
public enum ComponentLanguage {
    case ja
    case other
}

private final class DefaultTheme: Themeable {
    fileprivate var fonts: AppFont
    fileprivate var colors: AppColor
    fileprivate var radius: AppRadius
    
    init(fonts: AppFont = DefaultJPFont(scale: 1),
         colors: AppColor = DefaultAppColor(),
         radius: AppRadius = DefaultRadius()) {
        self.fonts = fonts
        self.colors = colors
        self.radius = radius
    }
}

public extension Bundle {
    static var components: Bundle = {
        Bundle(for: DefaultTheme.self)
    }()
}
