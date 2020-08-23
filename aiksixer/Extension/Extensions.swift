//
//  Extensions.swift
//  aiksixer
//
//  Created by Shishir Ahmed on 8/8/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func getInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
         let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
         UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
         defer { UIGraphicsEndImageContext() }
         draw(in: CGRect(origin: .zero, size: canvasSize))
         return UIGraphicsGetImageFromCurrentImageContext()
     }
}
