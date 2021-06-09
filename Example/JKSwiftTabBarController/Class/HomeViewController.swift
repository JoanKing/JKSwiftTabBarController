//
//  HomeViewController.swift
//  XCRTabBarController_Example
//
//  Created by 王冲 on 2020/1/9.
//  Copyright © 2020 SAINADE (Beijing) Information Technology Company Limited. All rights reserved.
//

import UIKit
import JKSwiftExtension

import JKSwiftTabBarController

class HomeViewController: UIViewController {
    
    /// 最大偏移量，超过此偏移量，显示回到顶部
    let maxOffset: CGFloat = 500
    /// 记录是否超过最大偏移量
    var isThanMaxOffset: Bool = false
    
    static let CellReuseIdentifier = "HomeIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        setTableview()
        if let currentVC = self.view.jk.currentVC {
            let className = currentVC.className
            print("🚀🚀🚀🚀🚀🚀🚀🚀当前的控制器：\(className)")
        }
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
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let profileViewController = ViewController()
        profileViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileViewController, animated: true)
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

extension HomeViewController: UIScrollViewDelegate, JKTabBarItemRepeatTouch {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > maxOffset  {
            
            if isThanMaxOffset { return }
            isThanMaxOffset = true
            
            print("当前的偏移量==\(scrollView.contentOffset.y)")
            // 发送通知改变tabbar图标
            print("发送通知改变tabbar图标--------回到顶部图标")
            //到顶通知父视图改变状态
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: self, userInfo: ["value":"1"])
        } else {
            if isThanMaxOffset {
                print("当前的偏移量==\(scrollView.contentOffset.y)")
                // 发送通知改变tabbar图标
                print("发送通知改变tabbar图标--------正常异行图标")
                isThanMaxOffset = false
                //到顶通知父视图改变状态
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: self, userInfo: ["value":"0"])
            }
        }
    }
    
    func tabBarSelfItemSelectedScrollTop() {
        print("-------------回到顶部------------")
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
