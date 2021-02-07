//
//  JKTabBarController.swift
//  XCRTabBarController_Example
//
//  Created by IronMan on 2020/8/27.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit

// MARK:- 底部Item点击协议和实现
/// 底部Item点击协议
public protocol JKTabBarItemRepeatTouch {
    /// 底部Item重复点击
    func tabBarItemRepeatTouch()
    /// 其他Item点击
    func tabBarOtherItemClick()
    /// 当前item将要被选中
    func tabBarSelfItemSelected(selectedIndex: Int)
    /// 滚动到顶部
    func tabBarSelfItemSelectedScrollTop()
}

public extension JKTabBarItemRepeatTouch {
    func tabBarItemRepeatTouch() { }
    func tabBarOtherItemClick() { }
    func tabBarSelfItemSelected(selectedIndex: Int) { }
    func tabBarSelfItemSelectedScrollTop() {}
}

// MARK:- UITabBarController 的配置
open class JKTabBarController: UITabBarController {
    /// TabBarView 属性
    public private(set) var tabBarView: JKTabBarView = JKTabBarView()
    
    // MARK: 设置图片
    /// 设置图片
    /// - Parameters:
    ///   - imageString: 图片的名称
    ///   - index: 位置
    ///   - animated: 是否要动画
    open func setUpItemImage(_ imageString: String, index: Int, animated: Bool = true) {
        self.tabBarView.setUpbarItemImage(imageString, index: index, animated: animated)
    }
    
    // MARK: 设置标题
    /// 设置标题
    /// - Parameters:
    ///   - titleString: 标题的名字
    ///   - index: 位置
    ///   - animated: 是否要动画
    open func setUpItemTitle(_ titleString: String, index: Int, animated: Bool = true) {
        self.tabBarView.setUpbarItemTitle(titleString, index: index, animated: animated)
    }

    // MARK: 设置提醒数，位置 访问调 JK.rootViewController?
    /// 设置提醒数，位置 访问调 JK.rootViewController?
    /// - Parameters:
    ///   - number: 数字
    ///   - index: 位置
    open func showBadgeNumber(_ number: Int?, index: Int) {
        guard let number = number else {
            return
        }
        self.tabBarView.showBadgeNumber(number, index: index)
    }
    
    // MARK: 设置小红点
    /// 设置小红点
    /// - Parameters:
    ///   - index: 位置
    ///   - isShow: 是否显示
    open func setRedPoint(at index: Int, isShow: Bool) {
        self.tabBarView.setRedPoint(at: index, isShow: isShow)
    }

    // MARK: 设置选中位置
    /// 设置选中位置
    open func setSelectedItem(at index: Int) {
        guard index < 5, index >= 0 else { return }
        changeIndex(index)
        selectedIndex = index
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        /// 解决tabBar在push操作时 上移问题
        setValue(JKTabBar(), forKey: "tabBar")
        commonInit()
    }

    // MARK: 布局视图
    private func commonInit() {
        tabBar.backgroundColor = UIColor.white
        tabBar.clipsToBounds = true
        tabBar.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { (make) in
            make.edges.equalTo(tabBar)
        }
    }
    
    // MARK: 设置选中的位置
    /// 设置选中的位置
    /// - Parameter index: 位置
    private func changeIndex(_ index: Int) {
        let preNavigationController = self.viewControllers![selectedIndex] as? UINavigationController
        let preFirstViewControler = preNavigationController?.viewControllers.first ?? viewControllers![selectedIndex]

        if let viewController = preFirstViewControler as? JKTabBarItemRepeatTouch, tabBarView.selectedIndex == index {
            viewController.tabBarItemRepeatTouch()
        }
       
        if tabBarView.selectedIndex != index {
            if let viewController = preFirstViewControler as? JKTabBarItemRepeatTouch {
                viewController.tabBarOtherItemClick()
            }
            let navigationController = self.viewControllers![index] as? UINavigationController
            let firstViewControler = navigationController?.viewControllers.first ?? viewControllers![index]
            if let viewController = firstViewControler as? JKTabBarItemRepeatTouch {
                viewController.tabBarSelfItemSelected(selectedIndex: index)
            }
        }
        
        if index == 0, tabBarView.isScrollTop {
            if let viewController = preFirstViewControler as? JKTabBarItemRepeatTouch {
                viewController.tabBarSelfItemSelectedScrollTop()
            }
        }
        tabBarView.selectedIndex = index
    }

    // MARK: UITabBarDelegate
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        changeIndex(index)
    }

    // MARK: GC
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 设置当前控制器支持的旋转方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        /*
        protrait: 竖屏
        landscape：横屏
        - 在当前的控制器中定义完成之后当前的控制器与当前控制器的字控制器都会遵守这个方向
        */
        return [.portrait]
    }
    
    /// 是否支持屏幕翻转
    override open var shouldAutorotate: Bool {
        return false
    }

    // MARK: LeftCycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 强制旋转成全屏
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

