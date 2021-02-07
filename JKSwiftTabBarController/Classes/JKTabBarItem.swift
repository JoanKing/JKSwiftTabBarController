//
//  JKTabBarItem.swift
//  XCRTabBarController_Example
//
//  Created by IronMan on 2020/8/27.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import SnapKit

// MARK:- 应用底部TabbarItem
// MARK: tabbar 下面的图片的类型
public enum JKTabbarType {
    /// 单张图片
    case singleImage
    /// 多张图片
    case gifImage
}
 
public class JKTabBarItem: UIView {
    // MARK:- Property
    /// 角标数量
    public var badgeNumber: Int? {
        didSet {
            showBadgeNumber(badgeNumber)
        }
    }
    /// 是否显示小红点
    public var showRedPointView: Bool = false {
        didSet {
            redPointView.isHidden = !showRedPointView
        }
    }
    /// 选中状态
    public var selected: Bool = false {
        didSet {
            if isAnimated {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopAnimated), object: nil)
                stopAnimated()
            }
            let status = selected ? UIControl.State.selected : UIControl.State.normal
            iconImageView.image = savebutton.image(for: status)
            bottomTitle.textColor = savebutton.titleColor(for: status)
            if selected, !oldValue {
                showAnimated()
            }
        }
    }
    /// 角标
    private var badgeLabel: UILabel!
    /// 小红点
    private var redPointView: UIView!
    /// 每个item的button
    private(set) var savebutton: UIButton = UIButton(type: .custom)
    /// 显示图标的UIImageView
    private var iconImageView: UIImageView!
    /// 图片
    private var imageName: String
    /// 图片的数量
    private var imageCount: Int = 25
    /*
     // TODO: iconImageView调用stopAnimating()之后动画不是立即停止，是在当前repeat结束后才停止，所以造成显示错误，目前没有找到解决方法，所以使用两个imageView，之后有解决方案后再优化
     */
    /// 动画view
    private let animatedImageView: UIImageView = UIImageView()
    /// 底部的标题
    internal var bottomTitle: UILabel!
    /// 标题
    public var title: String
    /// 默认的颜色
    private var titleNormalColor: UIColor
    /// 选中的的颜色
    private var titleSelectedColor: UIColor
    /// Tbabar的类型：默认单张图片
    private var tabbarType: JKTabbarType = .singleImage
    /// gif 类型动画的时长
    private var animationDuration: TimeInterval = 0
    
    // MARK: 本地的Tbabar配置
    private init(type: JKTabbarType, duration: TimeInterval, localImageCount: Int, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.tabbarType = type
        self.imageName = defaultImageName
        self.title = title
        self.titleNormalColor = titleColor
        self.titleSelectedColor = selectedTitleColor
        self.animationDuration = duration
        super.init(frame: CGRect.zero)
        initUI()
        commonInit()
        updateTheme()
        
        bottomTitle.text = title
        savebutton.setTitleColor(titleColor, for: .normal)
        savebutton.setTitleColor(selectedTitleColor, for: .selected)
        
        // gif 动画才往下面走
        guard type == .gifImage else {
            return
        }
        
        imageCount = localImageCount
        animatedImages.reserveCapacity(imageCount)
        for i in 0..<imageCount {
            if let image = UIImage(named: (imageName + "_selected\(i)")) {
                animatedImages.append(image)
            }
        }
    
        animatedImageView.animationDuration = duration
    }
    
    // MARK: 网络下载的Tbabar配置
    private init(type: JKTabbarType, fliePath: String, netWorkImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.imageName = defaultImageName
        self.title = title
        self.titleNormalColor = titleColor
        self.titleSelectedColor = selectedTitleColor
        self.animationDuration = duration
        super.init(frame: CGRect.zero)
        initUI()
        bottomTitle.text = title
        commonInit()
        
        redPointView.backgroundColor = UIColor.red
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor =  UIColor.red
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        
        savebutton.setTitleColor(titleColor, for: .normal)
        savebutton.setTitleColor(selectedTitleColor, for: .selected)
        
        if type == .gifImage, netWorkImageCount >= 2 {
            imageCount = netWorkImageCount
            animatedImages.reserveCapacity(netWorkImageCount)
            for i in 1...netWorkImageCount {
                let imageFilePath = "\(fliePath)_\(i).png"
                if let image = UIImage(contentsOfFile:imageFilePath) {
                    animatedImages.append(image)
                }
            }
            
            let normalImageFilePath = "\(fliePath)_1.png"
            let selectedImageFilePath = "\(fliePath)_\(netWorkImageCount).png"
            
            savebutton.setImage(UIImage(contentsOfFile:normalImageFilePath), for: .normal)
            savebutton.setImage(UIImage(contentsOfFile:selectedImageFilePath), for: .selected)
            
            animatedImageView.animationDuration = duration
        } else {
            imageCount = netWorkImageCount
            savebutton.setImage(UIImage(named: imageName), for: .normal)
            savebutton.setImage(UIImage(named: "\(imageName)_selected"), for: .selected)
        }
        resetSelectedStatus()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 切换动画
    /// 是否要展示动画
    public var isShowAnimated: Bool = true
    /// 动画图片
    public var animatedImages: [UIImage] = []
    private var isAnimated: Bool = false
    
    // MARK: 展示动画
    private func showAnimated() {
        guard isShowAnimated, !isAnimated, !animatedImages.isEmpty else { return }
        iconImageView.isHidden = true
        animatedImageView.isHidden = false
        animatedImageView.animationImages = animatedImages
        animatedImageView.startAnimating()
        perform(#selector(stopAnimated), with: nil, afterDelay: self.animationDuration, inModes: [RunLoop.Mode.common])
    }

    // MARK: 停止动画
    @objc private func stopAnimated() {
        animatedImageView.stopAnimating()
        isAnimated = false
        animatedImageView.isHidden = true
        iconImageView.isHidden = false
    }
}

// MARK:- 本地
extension JKTabBarItem {
    
    // MARK: 本地gif动画的Tabbar
    /// 本地gif动画的Tabbar
    /// - Parameters:
    ///   - localImageCount: 图片数量
    ///   - duration: 动画的时长
    ///   - title: 标题
    ///   - titleColor: 未选中的字体颜色
    ///   - selectedTitleColor: 选中的字体颜色
    ///   - defaultImageName: 默认的额图片
    public convenience init(localImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .gifImage, duration: duration, localImageCount: localImageCount, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName : defaultImageName)
    }
    
    // MARK: 本地普通的Tabbar
    /// 本地普通的Tabbar
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 未选中的字体颜色
    ///   - selectedTitleColor: 选中的字体颜色
    ///   - defaultImageName: 默认的额图片
    public convenience init(title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .singleImage, duration: 0, localImageCount: 0, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
}

// MARK:- 网络
extension JKTabBarItem {
    
    // MARK: 网络gif动画的Tabbar
    /// 网络gif动画的Tabbar
    /// - Parameters:
    ///   - fliePath: 沙盒路径
    ///   - netWorkImageCount: 图片的数量
    ///   - duration: 动画的时长
    ///   - title: 标题
    ///   - titleColor: 普通的颜色
    ///   - selectedTitleColor: 选中的颜色
    ///   - defaultImageName: 默认的图片
    public convenience init(fliePath: String, netWorkImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .gifImage, fliePath: fliePath, netWorkImageCount: netWorkImageCount, duration: duration, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
    
    // MARK: 网络普通的Tabbar
    /// 网络普通的Tabbar
    /// - Parameters:
    ///   - fliePath: 沙盒路径
    ///   - title: 标题
    ///   - titleColor: 普通的颜色
    ///   - selectedTitleColor: 选中的颜色
    ///   - defaultImageName: 默认的图片
    public convenience init(fliePath: String, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .gifImage, fliePath: fliePath, netWorkImageCount: 0, duration: 0, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
}

// MARK:- Private 属性布局、更新主题
extension JKTabBarItem {
    // MARK: 创建对应的控件
    /// 创建对应的控件
    private func initUI() {
        badgeLabel = UILabel(frame: CGRect.zero)
        badgeLabel.font = UIFont.systemFont(ofSize: 10)
        // badgeLabel.textInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
        badgeLabel.textAlignment = .center
        badgeLabel.isHidden = true
        badgeLabel.isUserInteractionEnabled = false
        badgeLabel.clipsToBounds = true
        badgeLabel.layer.cornerRadius = 15 / 2

        redPointView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        redPointView.layer.masksToBounds = true
        redPointView.layer.cornerRadius = 3
        redPointView.isHidden = true

        iconImageView = UIImageView()
        iconImageView.isUserInteractionEnabled = true

        animatedImageView.animationDuration = 1.0
        animatedImageView.animationRepeatCount = 1
        animatedImageView.isHidden = true

        bottomTitle = UILabel()
        bottomTitle.font = UIFont.systemFont(ofSize: 10)
        bottomTitle.textAlignment = .center
    }

    // MARK: 布局控件
    /// 布局控件
    private func commonInit() {
        badgeNumber = nil
        isExclusiveTouch = true
        backgroundColor = UIColor.clear
        addSubview(redPointView)
        addSubview(iconImageView)
        addSubview(animatedImageView)
        addSubview(bottomTitle)
        addSubview(badgeLabel)

        badgeLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        badgeLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        badgeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.greaterThanOrEqualTo(15)
            make.left.equalTo(iconImageView.snp.right).offset(-8)
            make.top.equalTo(self).offset(4)
        }
        redPointView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.right)
            make.centerY.equalTo(iconImageView.snp.top)
            make.width.height.equalTo(6)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(6.5)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        animatedImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(iconImageView)
        }
        bottomTitle.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(3)
            make.centerX.equalTo(self)
        }
    }
    
    // MARK: 更新控件属性
    /// 更新控件属性
    private func updateTheme() {
        redPointView.backgroundColor = UIColor.red
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor =  UIColor.red
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        setButtonDefaultStyle()
        resetSelectedStatus()
    }
    
    private func setButtonDefaultStyle() {
        savebutton.setTitleColor(self.titleNormalColor, for: .normal)
        savebutton.setTitleColor(self.titleSelectedColor, for: .selected)
        // 未选中图片没有黑夜效果
        savebutton.setImage(UIImage(named: imageName), for: .normal)
        savebutton.setImage(UIImage(named: "\(imageName)_selected"), for: .selected)
    }
    
    private func resetSelectedStatus() {
        let temp = selected
        selected = temp
    }
}

// MARK:- 方法
extension JKTabBarItem {
    
    // MARK: 设置被选中按钮的图片
    /// 设置被选中按钮的图片
    /// - Parameter imageString: 图片的名字
    func newChangeImage(imageString: String) {
        imageName = imageString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        iconImageView.image = savebutton.image(for: status)
        bottomTitle.textColor = savebutton.titleColor(for: status)
    }
    
    // MARK: 改变底部的标题
    /// 改变底部的标题
    /// - Parameter titleString: 新的标题名字
    func newChangeTitle(titleString: String) {
        title = titleString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        bottomTitle.textColor = savebutton.titleColor(for: status)
        bottomTitle.text = titleString
    }
    
    // MARK: 设置角标
    /// 设置角标
    /// - Parameter number: 角标的数字
    func showBadgeNumber(_ number: Int?) {
        if let number = number {
            switch number {
            case 0:
                badgeLabel.isHidden = true
            default:
                badgeLabel.isHidden = false
            }
            let text = number <= 999 ? "\(number)" : "999+"
            badgeLabel.text = text
        } else {
            badgeLabel.isHidden = true
        }
    }
}

// MARK:- 自定义 tabbar
/// 自定义 tabbar
public class JKTabBar: UITabBar {
    override public var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var temp = newValue
            if let superview = self.superview, temp.maxY != superview.frame.height {
                temp.origin.y = superview.frame.height - temp.height
            }
            super.frame = temp
        }
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90) {
                size.height += bottomInset
            }
        }
        return size
    }
}
