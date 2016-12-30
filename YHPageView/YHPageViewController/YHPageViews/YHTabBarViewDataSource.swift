//
//  YHTabBarViewDataSource.swift
//  YHPageView
//
//  Created by wuyunhai on 16/12/30.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit


@objc protocol YHTabBarViewDataSource : class {
    
    /* 
     * YHTabBarView-> return rightView
     * rightView.frame.orgin.y = default 0
     * rightView.frame.size.height = YHTabBarView.frame.size.height
     */
    @objc optional func tabBarRightView(_ tabBarView:YHTabBarView ) -> UIView?
    
    
    
    /* 
     * YHTabBarView-> return leftView
     * leftView.frame.orgin.y = default 0
     * leftView.frame.size.height = YHTabBarView.frame.size.height
     */
    @objc optional func tabBarLeftView(_ tabBarView:YHTabBarView ) -> UIView?
}
