//
//  JKBadgeLabel.swift
//  JKSwiftTabBarController
//
//  Created by IronMan on 2021/2/4.
//

import UIKit

// MARK:- 角标的设置
/// 可以指定contentInset、某几个圆角的Label
class JKBadgeLabel: UILabel {
    /// 指定圆角
    var corners: UIRectCorner
    /// 圆角尺寸
    var cornerSize: CGSize
    /// 文本inset
    var contentInset: UIEdgeInsets

    init(corners: UIRectCorner = .allCorners, cornerSize: CGSize = CGSize.zero, contentInset: UIEdgeInsets = UIEdgeInsets.zero) {
        self.corners = corners
        self.cornerSize = cornerSize
        self.contentInset = contentInset
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerSize)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height + contentInset.top + contentInset.bottom)
    }
    
}

