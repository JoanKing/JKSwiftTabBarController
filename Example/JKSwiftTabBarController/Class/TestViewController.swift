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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
