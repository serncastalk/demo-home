//
//  ScrollableSingleSectionItemView.swift
//  TestUIKit
//
//  Created by Duck Sern on 1/4/25.
//

import UIKit

@objcMembers
open class AIAScrollableSingleSectionItemView: UIView {
    
    public var onTap: ((Int) -> Void)?
    public var index: Int = 0
    public internal(set) var collapseSize: CGFloat = .zero
    public internal(set) var isFocus: Bool = false
    var identifier: String = ""
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
        clipsToBounds = true
    }
    
    @objc private func _onTap() {
        print("TAP INDEX :: ", index)
        onTap?(index)
    }
    
    open func prepareForReuse() {
        isFocus = false
    }
    
    open func didFocus() {
        isFocus = true
    }
    
    open func didLoseFocus() {
        isFocus = false
    }
    
    open func showContent() {
    }
    
    open func hideContent(isUp: Bool) {
        
    }
}
