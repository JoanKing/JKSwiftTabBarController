//
//  XCRMainViewController.swift
//  XCRTabBarController_Example
//
//  Created by WangJun on 2017/12/19.
//  Copyright © 2017年 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import JKSwiftTabBarController

class XCRMainViewController: JKTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = HomeViewController()
        vc1.view.backgroundColor = UIColor.white
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.white
        
        let vc3 = ViewController()
        vc3.view.backgroundColor = UIColor.yellow
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.white
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.white
        
        viewControllers = [vc1, vc2, vc3, vc4, vc5]
        
        // 测试读取本地图片
        /*
         tabBarView.barButtonItems = [
         XCRTabBarItem(imageName: "tabbar_home", title: "首页"),
         XCRTabBarItem(imageName: "tabbar_findcar", title: "找车"),
         XCRTabBarItem(imageName: "tabbar_xbb", title: "社区"),
         XCRTabBarItem(imageName: "tabbar_usecar", title: "用车"),
         XCRTabBarItem(imageName: "tabbar_me", title: "我")
         ]
         */
        
        // 测网络下载
        let titleColor = UIColor.brown
        let selectedColor =  UIColor.yellow
        let names:[String] = ["","","","","",""]
        let basePath = ""
        
        let tabBarItemOne = JKTabBarItem(fliePath: basePath.appending(names[0]), fileCount: 0, title: "首页", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName:"new_tabbar_home")
        
        tabBarView.barButtonItems = [
            tabBarItemOne,
            JKTabBarItem(fliePath: basePath.appending(names[2]), fileCount: 0, title: "社区", titleColor: titleColor, selectedTitleColor: selectedColor,defaultImageName:"new_tabbar_community"),
            JKTabBarItem(fliePath: basePath.appending(names[1]), fileCount: 0, title: "找车", titleColor: titleColor, selectedTitleColor: selectedColor,defaultImageName:"new_tabbar_me"),
            JKTabBarItem(fliePath: basePath.appending(names[3]), fileCount: 0, title: "用车", titleColor: titleColor, selectedTitleColor: selectedColor,defaultImageName:"new_tabbar_usecar"),
            JKTabBarItem(fliePath: basePath.appending(names[4]), fileCount: 0, title: "我", titleColor: titleColor, selectedTitleColor: selectedColor,defaultImageName:"new_tabbar_me")
        ]
        
        tabBarView.addObserver(self, forKeyPath: "selectedIndex", options: .new, context: nil)
        tabBarView.tabBarItem = tabBarItemOne
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabbarIcon), name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedIndex", let index = change?[NSKeyValueChangeKey(rawValue: "new")] as? Int {
            print("-------------------\(index)")
            tabBarView.clickOtherTabbarIcon(index: index)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //记得移除通知
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

extension XCRMainViewController {
    
    /// 改变icon
    /// - Parameter nofi: 通知参数
    @objc func changeTabbarIcon(nofi: Notification) {
        
        guard let value = nofi.userInfo!["value"] as? String else {
            return
        }
        tabBarView.changeHomeTabbarIcon(value: value)
    }
}
