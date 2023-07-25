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
import ZipArchive
class JKMainViewController: JKTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用本地的Tabbar
        localTabbar()
        // 网络的测试
        // networkTabbar()
        
        // 请忽略这个，这是我测试小火箭用的
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabbarIcon), name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: nil)

    }
    
    // MARK: 测试Item的添加和移除
    func testItemRemoveOrAdd() {
        JKAsyncs.asyncDelay(500) {
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
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        super.tabBar(tabBar, didSelect: item)
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        if index == 1 {
        }
        print("当前是：\(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 移除通知
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override var shouldAutorotate: Bool {
        let ret = self.selectedViewController?.shouldAutorotate ?? true
        return ret
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let ret = self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
        return ret
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}

// MARK:- Tabbar的配置
extension JKMainViewController {
    
    // MARK: 本地TabBar的配置
    /// 本地TabBar的配置
    func localTabbar() {
        let vc1 = JKNavigationController(rootViewController: HomeViewController())
        vc1.view.backgroundColor = UIColor.purple
        
        let vc2 = JKNavigationController(rootViewController: TradeViewController())
        vc2.view.backgroundColor = UIColor.white
        
        let vc3 = JKNavigationController(rootViewController: ProfileViewController())
        vc3.view.backgroundColor = UIColor.yellow
        
        viewControllers = [vc1, vc2, vc3]
        
        let titleColor = UIColor(hexString: "#444444")!
        let selectedColor = UIColor(hexString: "#5F00B4")!
        // 测试读取本地图片
        let tabBarItemOne = JKTabBarItem(localImageCount: 6, duration: 0.5, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "fb_quotes")
        // fb_trade
        // let tabBarItemTwo = JKTabBarItem(title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
        let tabBarItemTwo = JKTabBarItem(localImageCount: 6, duration: 0.5, title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "fb_trade")
        let tabBarItemThree = JKTabBarItem(title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
        
        tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree]
        tabBarView.tabBarItem = tabBarItemTwo
    }
    
    // MARK: 网络的TabBar的配置
    /// 网络的TabBar的配置
    func networkTabbar() {
        
        // 解压后的文件夹路径
        let basePath = FileManager.jk.DocumnetsDirectory() + "/JKTabbarInfo"
        let tabBarConfigPath = basePath + "/TabBarConfig.plist"
        guard let dictionary = NSDictionary(contentsOfFile: tabBarConfigPath),
              let titleColorString = dictionary.object(forKey: "titleColor") as? String,
              let selectedColorString = dictionary.object(forKey: "selectedColor") as? String,
              let names = dictionary.object(forKey: "titles") as? Array<String>,
              names.count > 0,
              let tabbars = dictionary.object(forKey: "Tabbars") as? Array<Dictionary<String,String>> else {
            // 本地沙盒没有就去加载本地的
            localTabbar()
            return
        }
        // names: tabbar的titles数组
        // 未选中的颜色
        let titleColor = UIColor(hexString: titleColorString)!
        // 选中的颜色
        let selectedColor = UIColor(hexString: selectedColorString)!
        
        var vcs: [UIViewController] = []
        var barButtonItems: [JKTabBarItem] = []
        for dic in tabbars {
            if let name = dic["title"], let defaultImageName = dic["defaultImageName"], let vcName = dic["ClassName"], let vc = vcName.jk.toViewController()  {
                let tabBarItem = JKTabBarItem(fliePath: "\(basePath)/\(name)", title: name, titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: defaultImageName)
                barButtonItems.append(tabBarItem)
                vcs.append(JKNavigationController(rootViewController: vc))
            }
        }
        viewControllers = vcs
        tabBarView.barButtonItems = barButtonItems
        tabBarView.tabBarItem = barButtonItems[0]
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
