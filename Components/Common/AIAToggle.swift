//
//  AIAToggle.swift
//  Components
//
//  Created by Duck Sern on 4/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIAToggle: UIView {
    public struct Configuration {
        var offBackground: UIColor = .appColor(\.middleGray)
        var onBackground: UIColor = .appColor(\.black)
        var thumbColor: UIColor = .appColor(\.white)
        
        public init(offBackground: UIColor, onBackground: UIColor, thumbColor: UIColor) {
            self.offBackground = offBackground
            self.onBackground = onBackground
            self.thumbColor = thumbColor
        }
        
        public init() {}
        
        public static let defaultConfiguration = Configuration()
    }
    
    private var configuration: Configuration = .init()
    private let thumbView = UIView()
    private var thumbTrailingContraint: Constraint?
    
    public var onInOnChange: ((Bool) -> Void)?
    
    public private(set) var isOn: Bool = false {
        didSet {
            onIsOnChange()
        }
    }
    
    public init(configuration: Configuration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(thumbView)
        thumbView.backgroundColor = configuration.thumbColor
        thumbView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.width.equalTo(thumbView.snp.height)
            make.leading.equalToSuperview().inset(2).priority(999)
            thumbTrailingContraint = make.trailing.equalToSuperview().inset(2).constraint
        }
        clipsToBounds = true
        setIsOn(false)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
    }
    
    @objc private func _onTap() {
        isOn.toggle()
        onInOnChange?(isOn)
    }
    
    private func onIsOnChange() {
        UIView.animate(withDuration: 0.2) {
            if self.isOn {
                self.thumbTrailingContraint?.activate()
            } else {
                self.thumbTrailingContraint?.deactivate()
            }
            self.backgroundColor = self.isOn ? self.configuration.onBackground : self.configuration.offBackground
            self.layoutIfNeeded()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        // topCT = 2, bottomCT = 2
        thumbView.layer.cornerRadius = (bounds.height - 4) / 2
    }
    
    public func setIsOn(_ value: Bool) {
        isOn = value
    }
    
    public func toggle() {
        isOn.toggle()
    }
}
