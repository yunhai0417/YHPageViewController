//
//  CustomViewController2.swift
//  YHPageView
//
//  Created by wuyunhai on 16/12/30.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class CustomViewController2: UIViewController , YHTabBarViewDelegate,YHTabBarViewDataSource{

    fileprivate var tabBarView:YHTabBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarView = YHTabBarView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        tabBarView?.delegate = self
        tabBarView?.dataSource = self
        view.addSubview(tabBarView!)
        view.backgroundColor = UIColor.green
        tabBarView?.reloadDataSource()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarLeftView(_ tabBarView: YHTabBarView) -> UIView? {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        let rightButton =  UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightButton.setImage(UIImage(named: "nn_catagory_all"), for: UIControlState())
        rightButton.setImage(UIImage(named: "nn_catagory_all"), for: UIControlState.highlighted)
        
        rightButton.addTarget(self, action: #selector(CustomViewController.rightBtnAction(_:)), for: UIControlEvents.touchUpInside)
        rightView.addSubview(rightButton)
        return rightView
    }

    func tabBarRightView(_ tabBarView: YHTabBarView) -> UIView? {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        let rightButton =  UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightButton.setImage(UIImage(named: "nn_catagory_all"), for: UIControlState())
        rightButton.setImage(UIImage(named: "nn_catagory_all"), for: UIControlState.highlighted)
        
        rightButton.addTarget(self, action: #selector(CustomViewController.rightBtnAction(_:)), for: UIControlEvents.touchUpInside)
        rightView.addSubview(rightButton)
        return rightView
    }
    
    
    func rightBtnAction(_ sender:UIButton){
        print("xxx")
    }
    
    
}
