//
//  UIImage+JKExtension.swift
//  XCRTabBarController_Example
//
//  Created by IronMan on 2020/8/27.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit

extension UIImage {
    public class func color(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        
        let scale = UIScreen.main.scale
        let fillRect = CGRect(x: 0, y: 0, width: size.width / scale, height: size.height / scale)
        UIGraphicsBeginImageContextWithOptions(fillRect.size, false, scale)
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color.cgColor)
        graphicsContext?.fill(fillRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
