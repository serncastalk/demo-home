//
//  AIAButtonStackView.swift
//  AIAVATAR
//
//  Created by Duc Nguyen on 18/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

public class AIAButtonStackView: UIView {
    public enum Group {
        case vertical(spacing: CGFloat = 8, _ actions: [Action])
        case horizontal(spacing: CGFloat = 8, _ actions: [Action])
        
        func body(buttonHeight: CGFloat) -> UIView {
            UIStackView().customized {
                $0.distribution = .fillEqually
                switch self {
                case .vertical(let spacing, let actions):
                    $0.axis = .vertical
                    $0.spacing = spacing
                    actions.map(\.body).map({
                        $0.customized {
                            $0.snp.makeConstraints {
                                $0.height.equalTo(buttonHeight)
                            }
                        }
                    }).forEach($0.addArrangedSubview(_:))
                case .horizontal(let spacing, let actions):
                    $0.axis = .horizontal
                    $0.spacing = spacing
                    actions.map(\.body).map({
                        $0.customized {
                            $0.snp.makeConstraints {
                                $0.height.equalTo(buttonHeight)
                            }
                        }
                    }).forEach($0.addArrangedSubview(_:))
                }
            }
        }
    }
    
    public enum Action {
        case action(title: String, style: AIAMainButton.Style, action: () -> Void, reference: ((UIButton) -> Void)? = nil)
        case custom(action: () -> UIButton, reference: ((UIButton) -> Void)? = nil)
        
        var body: UIView {
            switch self {
            case .action(let title, let style, let action, let reference):
                AIAMainButton(style: style).customized {
                    $0.setTitle(title, for: .normal)
                    $0.addAction(for: .touchUpInside, action)
                    reference?($0)
                }
            case .custom(let action, let reference):
                action().customized {
                    reference?($0)
                }
            }
        }
    }
    
    private let actions: [Group]
    private let spacing: CGFloat
    public var buttonHeight: CGFloat = 50
    
    public required init(actions: [Group], spacing: CGFloat = 8) {
        self.actions = actions
        self.spacing = spacing
        super.init(frame: .zero)
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) { fatalError("This function was unavailable") }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(body)
        body.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
    
    public lazy var body: UIView = {
        UIStackView().customized {
            $0.axis = .vertical
            $0.spacing = spacing
            actions.map({ $0.body(buttonHeight: buttonHeight) }).forEach($0.addArrangedSubview(_:))
        }
    }()
}
