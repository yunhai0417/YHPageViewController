//
//  YHPageViewHIddenBarDelegate.swift
//  NestiaUser
//
//  Created by 吴云海 on 16/12/26.
//  Copyright © 2016年 Nestia Pte Ltd. All rights reserved.
//  navBar 隐藏效果

import UIKit

@objc protocol YHPageViewHIddenBarDelegate : class {
    // 隐藏navBar
    func changeNavBarStatue(_ scrollview:UIScrollView,_ isHidden:Bool,_ currentOffset:CGFloat)
    
    // 获取当前nvBar的状态
    func currentNavBarSatue() -> Bool
}
