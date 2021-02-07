//
//  JKMainViewController.swift
//  XCRTabBarController_Example
//
//  Created by WangJun on 2017/12/19.
//  Copyright © 2017年 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import JKSwiftTabBarController

class JKMainViewController: JKTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localTabbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabbarIcon), name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        super.tabBar(tabBar, didSelect: item)
        
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        print("当前是：\(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.white
        
        let vc3 = ViewController()
        vc3.view.backgroundColor = UIColor.yellow
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.brown
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.green
        
        viewControllers = [JKNavigationController(rootViewController: vc1), JKNavigationController(rootViewController: vc2), JKNavigationController(rootViewController: vc3), JKNavigationController(rootViewController: vc4), JKNavigationController(rootViewController: vc5)]
        
        let titleColor = UIColor.blue
        let selectedColor =  UIColor.red
        // 测试读取本地图片
        let tabBarItemOne = JKTabBarItem(localImageCount: 6, duration: 0.5, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_home")
        let tabBarItemTwo = JKTabBarItem(title: "找车", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_community")
        let tabBarItemThree = JKTabBarItem(title: "社区", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_community")
        let tabBarItemFour = JKTabBarItem(title: "用车", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_usecar")
        let tabBarItemFive = JKTabBarItem(title: "我", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_me")
        
         tabBarView.barButtonItems = [
            tabBarItemOne, tabBarItemTwo, tabBarItemThree, tabBarItemFour, tabBarItemFive
         ]
        tabBarView.tabBarItem = tabBarItemTwo
    }
    
    // MARK: 网络的TabBar的配置
    /// 网络的TabBar的配置
    func networkTabbar() {
        // 测网络下载
        let names: [String] = ["","","","","",""]
        let basePath = ""
        
        let titleColor = UIColor.blue
        let selectedColor =  UIColor.red
        
        let tabBarItemOne = JKTabBarItem(fliePath: basePath, title: "首页", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_home")
        let tabBarItemTwo = JKTabBarItem(fliePath: basePath.appending(names[1]), title: "社区", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_home")
        let tabBarItemThree = JKTabBarItem(fliePath: basePath.appending(names[2]), title: "找车", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_usecar")
        let tabBarItemFour = JKTabBarItem(fliePath: basePath.appending(names[3]), title: "找车", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_usecar")
        let tabBarItemFive = JKTabBarItem(fliePath: basePath.appending(names[4]), title: "找车", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_usecar")
        
        tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree, tabBarItemFour, tabBarItemFive]
    }
}

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
