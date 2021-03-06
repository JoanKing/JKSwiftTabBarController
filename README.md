# JKSwiftTabBarController

[![CI Status](https://img.shields.io/travis/王冲/JKSwiftTabBarController.svg?style=flat)](https://travis-ci.org/王冲/JKSwiftTabBarController)
[![Version](https://img.shields.io/cocoapods/v/JKSwiftTabBarController.svg?style=flat)](https://cocoapods.org/pods/JKSwiftTabBarController)
[![License](https://img.shields.io/cocoapods/l/JKSwiftTabBarController.svg?style=flat)](https://cocoapods.org/pods/JKSwiftTabBarController)
[![Platform](https://img.shields.io/cocoapods/p/JKSwiftTabBarController.svg?style=flat)](https://cocoapods.org/pods/JKSwiftTabBarController)

## 使用说明
   - 支持本地和服务器，功能如下：
      - 目前JKSwiftTabBarController最多支持 5 个 item
      - 支持本地的 静态图和动态图(帧图)，暂时不支持网络的更新
      - 支持修改 TabbarView的背景色以及顶部横线的颜色
      - 支持角标
      - 支持红点
      - 支持切换item
      - 支持修改item底部的文字
      - 支持修改item底部的图片
      - 支持动态移除 item 和 添加 item
   - 静态图
      要求设置：选中和未选中图片，选中的图片是在未选中的后面 + `selected`，如：未选中是：`home`，则选中是：`home_selected`
   - 动态图(帧动画)
      对于图片的要求：需要设置未选中的图片、选中的图片、帧图片数组，如：选中的图片是在未选中的图片的后面加  `_selected`，而动态图是在选中的图片后面加1、2、3，如：选中的图片是 `home_selected`，那么帧图片是：`home_selected1`、`home_selected2`、`home_selected3`、`home_selected4`、`home_selected5`
## Example
   - 本地
     - 静态图
     
           let vc1 = HomeViewController()
           vc1.view.backgroundColor = UIColor.purple
        
           let vc2 = TradeViewController()
           vc2.view.backgroundColor = UIColor.white
          
           let vc3 = ProfileViewController()
           vc3.view.backgroundColor = UIColor.yellow
        
           viewControllers = [vc1, vc2, vc3]
        
           let titleColor = UIColor(hexString: "#444444")!
           let selectedColor = UIColor(hexString: "#5F00B4")!
        
           // 测试读取本地图片
           let tabBarItemOne = JKTabBarItem(title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_quotation")
           let tabBarItemTwo = JKTabBarItem(title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
           let tabBarItemThree = JKTabBarItem(title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
        
           tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree]
           tabBarView.tabBarItem = tabBarItemTwo
     - 动态图
     
           let vc1 = HomeViewController()
           vc1.view.backgroundColor = UIColor.purple
        
           let vc2 = TradeViewController()
           vc2.view.backgroundColor = UIColor.white
        
           let vc3 = ProfileViewController()
           vc3.view.backgroundColor = UIColor.yellow
        
           viewControllers = [vc1, vc2, vc3]
        
           let titleColor = UIColor(hexString: "#444444")!
           let selectedColor = UIColor(hexString: "#5F00B4")!
           // 测试读取本地图片
           let tabBarItemOne = JKTabBarItem(localImageCount: 5, duration: 0.5, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_quotation")
           let tabBarItemTwo = JKTabBarItem(localImageCount: 5, duration: 0.5, title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
           let tabBarItemThree = JKTabBarItem(localImageCount: 5, duration: 0.5, title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
           tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree]
           tabBarView.tabBarItem = tabBarItemTwo
   
   - 网络：在demo用我有写使用用例
       
         // 解压后的文件夹路径
         let basePath = FileManager.jk.DocumnetsDirectory() + "/JKTabbarInfo"
         let tabBarConfigPath = basePath + "/TabBarConfig.plist"
         guard let dictionary = NSDictionary(contentsOfFile: tabBarConfigPath),
             let titleColorString = dictionary.object(forKey: "titleColor") as? String,
             let selectedColorString = dictionary.object(forKey: "selectedColor") as? String,
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

## Requirements

    Swift5.0+

## Installation

    pod 'JKSwiftTabBarController'
     

## Author

王冲, jkironman@163.com

## License

JKSwiftTabBarController is available under the MIT license. See the LICENSE file for more info.
