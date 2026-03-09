//
//  BeforeTestPopup.swift
//  TestUIKit
//
//  Created by Duck Sern on 3/3/26.
//

import UIKit

final class BeforeTestPopup: UIViewController {
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        view.backgroundColor = .red
        let vc = TestPopup()
        present(vc, animated: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            let _vc = AvatarVoiceSelectionViewController()
//            self.navigationController?.pushViewController(_vc, animated: true)
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
