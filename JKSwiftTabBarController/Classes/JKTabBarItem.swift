//
//  JKTabBarItem.swift
//  XCRTabBarController_Example
//
//  Created by IronMan on 2020/8/27.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import SnapKit

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

/// 添加一下方法，iPhoneX push之后回来，页面会往上移
//    var oldSafeAreaInsets = UIEdgeInsets.zero
//
//    @available(iOS 11.0, *)
//    override func safeAreaInsetsDidChange() {
//        super.safeAreaInsetsDidChange()
//
//        if oldSafeAreaInsets != safeAreaInsets {
//            oldSafeAreaInsets = safeAreaInsets
//
//            invalidateIntrinsicContentSize()
//            superview?.setNeedsLayout()
//            superview?.layoutSubviews()
//        }
//    }

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

/// 应用底部TabViewItem
public class JKTabBarItem: UIView {
    // MARK: Property
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
    private(set) var savebutton: UIButton = UIButton(type: .custom)
    private var iconImageView: UIImageView!
    private var imageCount: Int = 25

    /*
     //TODO: iconImageView调用stopAnimating()之后动画不是立即停止，是在当前repeat结束后才停止，所以造成显示错误，目前没有找到解决方法，所以使用两个imageView，之后有解决方案后再优化
     */
    /// 动画view
    private let animatedImageView: UIImageView = UIImageView()
    internal var bottomTitle: UILabel!
    /// 图片
    private var imageName: String
    /// 标题
    public var title: String

    // MARK: - 调用本地图片初始化
    public init(imageName: String, title: String, isAlien: Bool = false) {
        self.imageName = imageName
        self.title = title
        super.init(frame: CGRect.zero)
        initUI()
        bottomTitle.text = title
        commonInit()
        updateTheme()
        imageCount = 25
        animatedImages.reserveCapacity(imageCount)
        for i in 0..<imageCount {
            if let image = UIImage(named: (imageName + "_\(i)")) {
                animatedImages.append(image)
            }
        }
        animatedImageView.animationDuration = Double(imageCount) * 40.0 / 1000.0
    }
    
    // MARK: - 用网络下载的图片显示Tabbar item
    public init(fliePath: String,fileCount:Int, title: String,titleColor: UIColor,selectedTitleColor:UIColor,defaultImageName: String) {
        self.imageName = defaultImageName
        self.title = title
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
        
        if fileCount >= 2 {
            imageCount = fileCount
            animatedImages.reserveCapacity(fileCount)
            for i in 1...fileCount {
                let imageFilePath = "\(fliePath)_\(i).png"
                if let image = UIImage(contentsOfFile:imageFilePath) {
                    animatedImages.append(image)
                }
            }
            
            let normalImageFilePath = "\(fliePath)_1.png"
            let selectedImageFilePath = "\(fliePath)_\(fileCount).png"
            
            savebutton.setImage(UIImage(contentsOfFile:normalImageFilePath), for: .normal)
            savebutton.setImage(UIImage(contentsOfFile:selectedImageFilePath), for: .selected)
            
        } else {
            imageCount = 25
            animatedImages.reserveCapacity(imageCount)
            for i in 0..<imageCount {
                if let image = UIImage(named: (imageName + "_\(i)")) {
                    animatedImages.append(image)
                }
            }
            savebutton.setImage(UIImage(named: imageName), for: .normal)
            savebutton.setImage(UIImage(named: "\(imageName)_selected"), for: .selected)
        }
        
        animatedImageView.animationDuration = Double(imageCount) * 40.0 / 1000.0
        
        resetSelectedStatus()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
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
    
    private func updateTheme() {
        redPointView.backgroundColor = UIColor.red
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor =  UIColor.red
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        setButtonDefaultStyle()
        resetSelectedStatus()
    }
    
    private func setButtonDefaultStyle() {
        savebutton.setTitleColor(UIColor.brown, for: .normal)
        savebutton.setTitleColor(UIColor.brown, for: .selected)
        ///未选中图片没有黑夜效果
        savebutton.setImage(UIImage(named: imageName), for: .normal)
        savebutton.setImage(UIImage(named: "\(imageName)_selected"), for: .selected)
    }
    
    private func resetSelectedStatus() {
        let temp = selected
        selected = temp
    }
    
    func newChangeImage(imageString: String) {
        imageName = imageString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        iconImageView.image = savebutton.image(for: status)
        bottomTitle.textColor = savebutton.titleColor(for: status)
    }
    
    func newChangeTitle(titleString: String) {
        title = titleString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        bottomTitle.textColor = savebutton.titleColor(for: status)
        bottomTitle.text = titleString
    }

    // MARK: - 切换动画
    /// 是否要展示动画
    public var isShowAnimated: Bool = true
    /// 动画图片
    public var animatedImages: [UIImage] = []
    private var isAnimated: Bool = false
    
    private func showAnimated() {
        guard isShowAnimated, !isAnimated, !animatedImages.isEmpty else { return }
        iconImageView.isHidden = true
        animatedImageView.isHidden = false
        animatedImageView.animationImages = animatedImages
        animatedImageView.startAnimating()
        perform(#selector(stopAnimated), with: nil, afterDelay: Double(imageCount) * 40.0 / 1000.0, inModes: [RunLoop.Mode.common])
    }

    @objc private func stopAnimated() {
        animatedImageView.stopAnimating()
        isAnimated = false
        animatedImageView.isHidden = true
        iconImageView.isHidden = false
    }
}
