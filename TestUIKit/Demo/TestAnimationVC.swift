//
//  TestAnimationVC.swift
//  TestUIKit
//
//  Created by Duck Sern on 23/8/25.
//

import UIKit

var x: TestAnimationVC!

final class TestAnimationVC: UIViewController {
    
    let _dele = TestLayerDelegate()
    
    var hihi: TestAnimationVC!
    
    deinit {
        print("SERN :: before", CFGetRetainCount(self))
        x = self
        print("SERN :: after", CFGetRetainCount(self))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("SERN ::", CFGetRetainCount(self))
        //hihi = self
        //print("SERN :: after", CFGetRetainCount(self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let subV = CustomLayerUIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(subV)
        subV.backgroundColor = .red
        subV.center = .init(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        subV.bounds.size = .init(width: 100, height: 100)
        
        //self.subV.layer.delegate = _dele
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            print("HEHEHHE")
            self.subV.center.x += 100
            
            UIView.animate(withDuration: 0.2) {
                print("SERN :: called")
                print("SERN :: ", self.subV)
                print("SERN :: ", self.subV.layer.delegate)
                self.subV.center.x += 100
            }
        })
    }
}

final class TestLayerDelegate: NSObject, CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> (any CAAction)? {
        print("SERN :: ", #function, event)
        return nil
    }
}

final class CustomLayer: CALayer {
    override class func defaultAction(forKey event: String) -> (any CAAction)? {
        print("SERN :: ", #function)
        return nil
    }
    
    override var position: CGPoint {
        didSet {
            print("SERN ??????", position.x)
        }
    }
}

final class CustomLayerUIView: UIView {
    override class var layerClass: AnyClass {
        CustomLayer.self
    }
    
    override func action(for layer: CALayer, forKey event: String) -> (any CAAction)? {
        print("SERN :: CustomLayerUIView :: ", #function)
        return nil
    }
    
}
