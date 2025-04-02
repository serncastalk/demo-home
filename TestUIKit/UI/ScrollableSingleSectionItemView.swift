//
//  ScrollableSingleSectionItemView.swift
//  TestUIKit
//
//  Created by Duck Sern on 1/4/25.
//

import UIKit

class ScrollableSingleSectionItemView: UIView {
    
    var onTap: ((Int) -> Void)?
    var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
    }
    
    @objc private func _onTap() {
        print("TAP INDEX :: ", index)
        onTap?(index)
    }
    
    func showContent() {
    }
    
    func hideContent() {
        
    }
}
