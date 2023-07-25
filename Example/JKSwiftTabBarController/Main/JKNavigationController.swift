//
//  JKNavigationController.swift
//  JKSwiftTabBarController_Example
//
//  Created by IronMan on 2021/2/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class JKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        print("\(self.className)：\(self.viewControllers.last ?? UIViewController()) 方向：\(self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait)")
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
