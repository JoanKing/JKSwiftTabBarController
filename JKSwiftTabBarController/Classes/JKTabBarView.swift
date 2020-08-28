//
//  JKTabBarView.swift
//  XCRTabBarController_Example
//
//  Created by IronMan on 2020/8/27.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import SnapKit
// import TTTAttributedLabel

/// 首页底部tabView
public class JKTabBarView: UIView {
    // MARK: - Property
    
    /// 保存首页的 item
    public var tabBarItem: JKTabBarItem?
    /// 是否要回到顶部
    var isScrollTop: Bool = false
    /// 上次选中的位置
    var oldIndex: Int = 0
    
    /// 设置按钮
    public var barButtonItems: [JKTabBarItem] = [] {
        didSet {
            for item in oldValue {
                item.removeFromSuperview()
            }
            var lastItem: UIView? = nil
            for (index, item) in barButtonItems.enumerated() {
                contentView.addSubview(item)
                item.snp.makeConstraints({ (make) in
                    if let lastItem = lastItem {
                        make.left.equalTo(lastItem.snp.right)
                        make.width.equalTo(lastItem)
                    } else {
                        make.left.equalTo(contentView)
                    }
                    make.top.bottom.equalTo(contentView)
                })
                if index == self.selectedIndex {
                    item.selected = true
                }
                lastItem = item
            }
            if let lastItem = lastItem {
                lastItem.snp.makeConstraints({ (make) in
                    make.right.equalTo(contentView.snp.right)
                })
            }
        }
    }
    
    /// 选中的项目(上次选中的item)
    @objc dynamic var selectedIndex: Int = 0 {
        didSet {
            if oldValue >= barButtonItems.count && selectedIndex >= barButtonItems.count {
                return
            }
            if selectedIndex == oldValue {
                return
            }
            let oldItem = barButtonItems[oldValue]
            oldItem.selected = false
            let newItem = barButtonItems[selectedIndex]
            newItem.selected = true
            // showFrameAnimated(false)
        }
    }
    /// 是否显示 我的 小红点
    public var showMeRedPointView: Bool = false {
        didSet {
        }
    }
    
    /// 是否显示 用车  小红点
    public var showUseCarRedPointView: Bool = false {
        didSet {
        }
    }
    
    /// item的contentView
    private var contentView: UIView = UIView()
    /// 这条横线是为了 遮挡系统底部的横线
    private var topLine: UIView = UIView()
    /// tabbar 背景色 图片
    private var blurImageView: UIImageView = UIImageView()
    /// tabbar 渐变色背景色 view
    private var gradientView: JKTabBarGradientView!
    
    /// 红点的数组
    var redViewArray: [UIView] = []
    // 角标的数组
    var badgeLabel: [UILabel] = []
    
    // MARK: - LifeCycle
    init() {
        super.init(frame: CGRect.zero)
        
        gradientView = JKTabBarGradientView()
        addSubview(gradientView)
        addSubview(blurImageView)
        addSubview(contentView)
        addSubview(topLine)
        
        gradientView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        blurImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-1)
            make.height.equalTo(1)
        }
        
        updateTheme()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /**
     设置选中按钮图片
     - parameter imageString: 图片名称
     - parameter index:  位置
     */
    func setUpbarItemImage(_ imageString: String, index: Int, animated: Bool = true) {
        if barButtonItems.count <= index { return }
        let barItem = barButtonItems[index]
        barItem.isShowAnimated = animated
        barItem.newChangeImage(imageString: imageString)
    }
    
    func setUpbarItemTitle(_ titleString: String, index: Int, animated: Bool = true) {
        if barButtonItems.count <= index { return }
        let barItem = barButtonItems[index]
        barItem.isShowAnimated = animated
        barItem.newChangeTitle(titleString: titleString)
    }
    
    /**
     设置提醒数，位置
     - parameter number: 数字
     - parameter index:  位置
     */
    func showBadgeNumber(_ number: Int?, index: Int) {
        if barButtonItems.count <= index { return }
        let item = barButtonItems[index]
        item.badgeNumber = number
    }
    
    /**
     设置小红点
     - parameter index:        位置
     - parameter showOrHidden: 是否显示
     */
    func setRedPoint(at index: Int, isShow: Bool) {
        if barButtonItems.count <= index { return }
        let item = barButtonItems[index]
        item.showRedPointView = isShow
    }
    
    func showAddImage(isShow: Bool) {}
    
    func showAnimation() {}
    
    func closeAnimation() {}
    
    func postAnimation() {}
    
    private func updateTheme() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        topLine.backgroundColor = UIColor.white
    }
  
    public func restDefaultBGColor() {
        blurImageView.image = UIImage.color(UIColor.red)
        gradientView.isHidden = true
        blurImageView.isHidden = false
    }
    
    public func setBackgroundImage(image: UIImage) {
        blurImageView.image = image
        gradientView.isHidden = true
        blurImageView.isHidden = false
    }
    
    public func setBackgroundColors(beginColor:UIColor, endColor: UIColor) {
        gradientView.resetColor(beginColor: beginColor, endColor: endColor)
        gradientView.isHidden = false
        blurImageView.isHidden = true
    }
}

//MARK: - 改变首页的 TabbarIcon
extension JKTabBarView {

    /// 改变底部首页的内容
    /// - Parameters:
    ///   - value: 1 显示小火箭 ，其他值显示异行图
    ///   - topImage: 小火箭的图片
    ///   - homeSelectImage: 正常选中的图片
    public func changeHomeTabbarIcon(value: String?, topImage: String = "new_tabbar_home_rocket", homeSelectImage: String = "new_tabbar_home_selected") {
        guard value != nil else {
            return
        }
        guard let _ = tabBarItem else {
            return
        }
    }
    
    /// 点击tabar的反应
    /// - Parameters:
    ///   - index: 点击的第几个
    ///   - topImage: 小火箭的图片
    ///   - homeSelectImage: 正常选中的图片
    public func clickOtherTabbarIcon(index: Int?, topImage: String = "new_tabbar_home_rocket", homeSelectImage: String = "new_tabbar_home_selected") {
        
        guard let index = index else {
            return
        }
        
        if oldIndex > 0 && index > 0 { return }
        
        // 如果上次和这次点击的一样就返回
        if oldIndex == index { return }
        // 记录上次点击的位置
        oldIndex = index
    }
}

/// 渐变背景色
class JKTabBarGradientView: UIView {
    override class var layerClass: Swift.AnyClass { return CAGradientLayer.self }
    
    // MARK: - LiefCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        changeTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let gradient = layer as! CAGradientLayer
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    private func changeTheme() {
        let gradient = layer as! CAGradientLayer
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
    }
    
    func resetColor(beginColor:UIColor, endColor: UIColor) {
        let gradient = layer as! CAGradientLayer
        gradient.colors = [beginColor.cgColor, endColor.cgColor]
    }
}

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

