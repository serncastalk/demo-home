//
//  R10PlayGroundVC.swift
//  TestUIKit
//
//  Created by Duck Sern on 25/8/25.
//

import UIKit
import SnapKit

final class R10PlayGroundVC: UIViewController {
    private var levelsView: [R10StageView] = [
        R10StageView(position: .mid, title: "Ball Juggle"),
        R10StageView(position: .left, title: "Ball Juggle"),
        R10StageView(position: .right, title: "Ball Juggle"),
        R10StageView(position: .mid, title: "Ball Juggle"),
        R10StageView(position: .left, title: "Ball Juggle"),
        R10StageView(position: .mid, title: "Ball Juggle")
    ].reversed()
    private var pathViews: [R10AnimateShapeView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerStackView = {
            let v = UIStackView(arrangedSubviews: levelsView)
            v.axis = .vertical
            v.spacing = 0
            v.distribution = .fillEqually
            return v
        }()
        levelsView.first?.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
        
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        let count = levelsView.count
        var i = count - 1
        while (i > 0) {
            let curr = levelsView[i]
            let next = levelsView[i - 1]
            let pathView = R10AnimateShapeView()
            view.insertSubview(pathView, at: 0)
            pathViews.append(pathView)
            let isLeftToRight: Bool = {
                switch curr.position {
                case .left:
                    return true
                case .mid:
                    if next.position == .right {
                        return true
                    }
                case .right:
                    break
                }
                return false
            }()
            
            pathView.generatePath = { bounds in
                let path = CGMutablePath()
                if isLeftToRight {
                    path.move(to: bounds.bottomLeft)
                    path.addLine(to: bounds.topRight)
                } else {
                    path.move(to: bounds.bottomRight)
                    path.addLine(to: bounds.topLeft)
                }
                return path
            }
            
            pathView.snp.makeConstraints { make in
                make.top.equalTo(next.snp.bottom)
                make.bottom.equalTo(curr.circleView.snp.centerY)
                if isLeftToRight {
                    make.trailing.equalTo(next.circleView.snp.leading)
                    make.leading.equalTo(curr.circleView.snp.trailing)
                } else {
                    make.trailing.equalTo(curr.circleView.snp.leading)
                    make.leading.equalTo(next.circleView.snp.centerX)
                }
            }
            i -= 1
        }
    }
    
    var pathsIndex = 0
    func startAnim() {
        guard pathsIndex < pathViews.count else {
            
            return
        }
        pathViews[pathsIndex].startAnim { [weak self] in
            guard let self = self else { return }
            self.pathsIndex += 1
            self.startAnim()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnim()
    }
}

extension CGRect {
    var topLeft: CGPoint { .init(x: minX, y: minY) }
    var topRight: CGPoint { .init(x: maxX, y: minY) }
    var bottomLeft: CGPoint { .init(x: minX, y: maxY) }
    var bottomRight: CGPoint { .init(x: maxX, y: maxY) }
}
