//
//  JKMainViewController.swift
//  XCRTabBarController_Example
//
//  Created by WangJun on 2017/12/19.
//  Copyright © 2017年 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import JKSwiftTabBarController
import JKSwiftExtension
class JKMainViewController: JKTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用本地的Tabbar
        localTabbar()
        
        JKAsyncs.asyncDelay(5) {
        } _: {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.removeTabbarItem(index: 1)
            JKAsyncs.asyncDelay(5) {
            } _: {[weak self] in
                guard let weakSelf = self else { return }
                let vc2 = TradeViewController()
                vc2.view.backgroundColor = UIColor.white
                let titleColor = UIColor(hexString: "#444444")!
                let selectedColor = UIColor(hexString: "#5F00B4")!
                let tabBarItemTwo = JKTabBarItem(title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
                weakSelf.insertTabbarItem(index: 1, item: tabBarItemTwo, vc: JKNavigationController(rootViewController: vc2))
            }
        }
        
        // 请忽略这个，这是我测试小火箭用的
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabbarIcon), name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        super.tabBar(tabBar, didSelect: item)
        
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        print("当前是：\(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 移除通知
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- Tabbar的配置
extension JKMainViewController {
    
    // MARK: 本地TabBar的配置
    /// 本地TabBar的配置
    func localTabbar() {
        let vc1 = HomeViewController()
        vc1.view.backgroundColor = UIColor.purple
        
        let vc2 = TradeViewController()
        vc2.view.backgroundColor = UIColor.white
        
        let vc3 = ProfileViewController()
        vc3.view.backgroundColor = UIColor.yellow
        
        viewControllers = [JKNavigationController(rootViewController: vc1), JKNavigationController(rootViewController: vc2), JKNavigationController(rootViewController: vc3)]
        
        let titleColor = UIColor(hexString: "#444444")!
        let selectedColor = UIColor(hexString: "#5F00B4")!
        // 测试读取本地图片
        let tabBarItemOne = JKTabBarItem(localImageCount: 5, duration: 0.5, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_quotation")
        let tabBarItemTwo = JKTabBarItem(title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
        let tabBarItemThree = JKTabBarItem(title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
        
        tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree]
        tabBarView.tabBarItem = tabBarItemTwo
    }
    
    // MARK: 网络的TabBar的配置
    /// 网络的TabBar的配置
    func networkTabbar() {
        // 测网络下载
        let names: [String] = ["","","","","",""]
        let basePath = ""
        
        let titleColor = UIColor(hexString: "#444444")!
        let selectedColor = UIColor(hexString: "#5F00B4")!
        
        let tabBarItemOne = JKTabBarItem(fliePath: basePath, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_quotation")
        let tabBarItemTwo = JKTabBarItem(fliePath: basePath.appending(names[1]), title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
        let tabBarItemThree = JKTabBarItem(fliePath: basePath.appending(names[2]), title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
        
        tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree]
    }
}

// MARK:- 请忽略这个，这是我测试小火箭用的
extension JKMainViewController {
    /// 改变icon
    /// - Parameter nofi: 通知参数
    @objc func changeTabbarIcon(nofi: Notification) {
        guard let value = nofi.userInfo!["value"] as? String else {
            return
        }
        tabBarView.changeHomeTabbarIcon(value: value)
    }
}
