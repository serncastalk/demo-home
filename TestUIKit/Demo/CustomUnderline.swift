//
//  CustomUnderline.swift
//  TestUIKit
//
//  Created by Duck Sern on 27/12/25.
//

import UIKit
/// https://medium.com/brill-app/implementing-custom-underline-styles-866c740be78a
extension NSUnderlineStyle {

    static var patternLargeDot: NSUnderlineStyle {
        return NSUnderlineStyle(rawValue: 0x11)
    }
    
}

final class CustomNSLayoutManager: NSLayoutManager {
    override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        guard underlineVal == .patternLargeDot else {
            super.drawUnderline(forGlyphRange: glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
            return
        }
        let container = textContainer(forGlyphAt: glyphRange.location,
                                      effectiveRange: nil)!
        let rect = boundingRect(forGlyphRange: glyphRange, in: container)
        let offsetRect = rect.offsetBy(dx: containerOrigin.x,
                                       dy: containerOrigin.y)
        drawUnderline(under: offsetRect)
    }
    
    func drawUnderline(under rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 6
        path.lineCapStyle = .round
        path.setLineDash([0, 14], count: 2, phase: 0)
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.stroke()
    }
}

final class TestCustomUnderline: UIViewController {
    lazy var textView: UITextView = {
        let layout = CustomNSLayoutManager()
        let storage = NSTextStorage()
        storage.addLayoutManager(layout)
        let initialSize = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        let container = NSTextContainer(size: initialSize)
        container.widthTracksTextView = true
        layout.addTextContainer(container)
        let textView = UITextView(frame: .zero, textContainer: container)
        textView.isEditable = false
        textView.isScrollEnabled = false
        //textView.isSelectable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        textView.backgroundColor = .red
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
        
        let text = "All of this just to underline some text? Cool."
        let range = NSRange(location: 20, length: 20)

        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.patternLargeDot.rawValue,
                                    range: range)
        attributedText.addAttribute(.underlineColor,
                                    value: UIColor.green,
                                    range: range)
        textView.attributedText = attributedText
    }
}
