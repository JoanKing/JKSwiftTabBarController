//
//  ProfileViewController.swift
//  JKSwiftTabBarController_Example
//
//  Created by IronMan on 2021/2/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import JKSwiftExtension
class ProfileViewController: UIViewController {
    static let CellReuseIdentifier = "ProfileIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        self.view.backgroundColor = .randomColor
        setTableview()
        
        print("\(FileManager.jk.DocumnetsDirectory())")
    }
    
    // MARK: tableView的设置
    func setTableview() {
        self.edgesForExtendedLayout = []
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: HomeViewController.CellReuseIdentifier)
    }
    
    lazy var tableView : UITableView = {
        let nav_height: CGFloat = UIScreen.main.bounds.height >= 812 ? 88 : 64
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - nav_height - kTabbarFrameH), style:.grouped)
        if #available(iOS 11, *) {
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }
        // tableview的背景色
        tableView.backgroundColor = UIColor.white
        // tableview挂代理
        tableView.delegate = self
        tableView.dataSource = self
        // tableview的分割方式
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
}

// MARK:- 代理
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: tableView段里面的 段落 数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: tableView段里面的 行 数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    // MARK: tableView cell 的设置
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.CellReuseIdentifier, for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.randomColor
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    // MARK: tableView 的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.section)段,\(indexPath.row)行")
//        let profileViewController = ViewController()
//        profileViewController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(profileViewController, animated: true)
       
        self.navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    // MARK: tableView cell 的高度返回值
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        headView1.backgroundColor = UIColor.randomColor
        return headView1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01))
        footView1.backgroundColor = UIColor.purple
        return footView1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

