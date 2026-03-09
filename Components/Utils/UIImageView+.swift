//
//  UIImageView+.swift
//  Components
//
//  Created by Sonny on 14/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

//import SDWebImage
import UIKit

extension UIImageView {
    public func load(url: String?, placeHolder: UIImage? = nil) {
        guard
            let urlString = url,
            let urlQuery = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlQuery)
        else { return }
        
        //self.sd_setImage(with: url, placeholderImage: placeHolder)
    }
    
    public func load(_ url: String?, placeHolder: UIImage? = nil) {
        //self.sd_setImage(with: URL(string: url ?? ""), placeholderImage: placeHolder)
    }
}
