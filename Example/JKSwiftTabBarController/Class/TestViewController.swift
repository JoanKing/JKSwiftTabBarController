//
//  TestViewController.swift
//  JKSwiftTabBarController_Example
//
//  Created by IronMan on 2021/2/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .brown
        
        let sender = UIButton(type: .custom)
        self.view.addSubview(sender)
        
        if let currentVC = sender.jk.currentVC {
            let className = currentVC.className
            print("🚀🚀🚀🚀🚀🚀🚀🚀-------sender 当前的控制器：\(className)")
        }
        
        
        if let currentVC = self.view.jk.currentVC {
            let className = currentVC.className
            print("🚀🚀🚀🚀🚀🚀🚀🚀-------self.view当前的控制器：\(className)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        JK.mainViewController.setSelectedItem(at: 1)
    }
    
    //是否自动旋转:需要横屏的视图控制器中覆写此方法，返回YES
    override var shouldAutorotate: Bool {
        return true
    }
    
    //支持哪些屏幕方向:只支持竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        print("\(self.className)：支持横屏")             
        return [.landscapeLeft, .portrait]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
