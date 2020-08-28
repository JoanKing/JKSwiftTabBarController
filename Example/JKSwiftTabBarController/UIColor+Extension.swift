//
//  UIColor+Extension.swift
//  XCRTabBarController_Example
//
//  Created by 王冲 on 2020/1/9.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 随机色
    class var randomColor: UIColor {
        return .rgbColor(r: CGFloat(arc4random()%256) , g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256), a: 1.0)
    }

    /// RGBA的颜色设置
    static func rgbColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
}
