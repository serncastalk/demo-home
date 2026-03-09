//
//  RootViewController.swift
//  TestUIKit
//
//  Created by Duck Sern on 24/11/25.
//

import UIKit

class RootViewController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGR)
        
        DispatchQueue.main.async {
            let vc = ViewController()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .yellow
    }
    
    @objc func onTap() {
        print("SERN :: root")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("SERN :: touch began")
    }
}
