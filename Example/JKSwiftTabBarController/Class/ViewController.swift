//
//  ViewController.swift
//  JKSwiftTabBarController
//
//  Created by 王冲 on 08/27/2020.
//  Copyright (c) 2020 王冲. All rights reserved.
//

import UIKit
import JKSwiftExtension
import JKSwiftTabBarController
import ZipArchive
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "测试控制器"
        self.view.backgroundColor = .randomColor
    }
    
    // 解压测试
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let zip = ZipArchive()
        // zip包的名字
        let foldName = "JKTabbarInfo"
        // 下载后的zip路径
        let zipPath = FileManager.jk.DocumnetsDirectory() + "/\(foldName).zip"
        // 防止下载文件名重复
        let extName = String(Date().timeIntervalSince1970)
        // 检查是否可解压
        if zip.unzipOpenFile(zipPath) {
            // 解压后的路径
            let unzipPath = zipPath + extName
            // 解压
            if zip.unzipFile(to: unzipPath, overWrite: true) {
                // 移除原先下载的zip文件路径
                FileManager.jk.removefile(filePath: zipPath)
                // 移动解压后的文件到Documnets路径下
                FileManager.jk.moveFile(type: .directory, fromeFilePath: unzipPath + "/\(foldName)", toFilePath: FileManager.jk.DocumnetsDirectory() + "/\(foldName)")
                // 删除临时解压的路径
                FileManager.jk.removefile(filePath: unzipPath)
            }
        }
    }
}
