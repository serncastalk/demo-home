//
//  TestTooltipView.swift
//  TestUIKit
//
//  Created by Duck Sern on 14/12/25.
//

import UIKit
import SnapKit

class TestTooltipView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Do any additional setup after loading the view.
        let bubbleView = OBDTooltipUpGradientBubbleView()
        view.addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        view.backgroundColor = .yellow*/
        view.backgroundColor = .yellow
        let button = Button()
        button.backgroundColor = .red
        
        
        let overlay = UIView()
        view.addSubview(overlay)
        overlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.onTapBgr))
        overlay.addGestureRecognizer(tapGR)
        //tapGR.cancelsTouchesInView = false
        
        overlay.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
//            make.size.equalTo(200)
        }
        UIImage.iccC
        button.isEnabled = true
        button.setTitle("SERN", for: .normal)
        button.addTarget(self, action: #selector(self.onTap), for: .touchUpInside)
    }
    
    @objc func onTap() {
        print("SERN ::")
    }
    
    @objc func onTapBgr() {
        print("SERN :: backgr")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

final class Button: UIButton {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let ret = super.gestureRecognizerShouldBegin(gestureRecognizer)
        return true
//        return ret
    }
}
