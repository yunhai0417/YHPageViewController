//
//  YHPageViewDataSource.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

@objc protocol YHPageViewDataSource : class {
    
    
    
    func numberOfControllers(_ pageView:YHPageViewController) -> Int
    
    func pageView(_ pageView:YHPageViewController,controllerAtIndex index:Int) ->UIViewController
    
    //设置右边view
    func pageTabRightView(_ pageView:YHPageViewController) ->UIView?
    
    //设置pageTabview->CGRect
    func pageViewTopSize(_ pageView:YHPageViewController) ->CGRect
    
    //设置PageScrollviewSize
    func pageScrollViewSize(_ pageView:YHPageViewController) ->CGRect
    
    //获取title 文字
    func pageView(_ pageView:YHPageViewController,titleAtIndex index:Int) -> String
    
    
    //设置title font
    func pageView(_ pageView:YHPageViewController,titleFontAtIndex index:Int)->UIFont
    
    //设置button
    func pageTabScrollview(_ pageView:YHPageViewController,buttonAtIndex index:Int)->UIButton
    
    //设置tabscrollview 边距
    func pageTabScrollview(_ pageView:YHPageViewController)->UIEdgeInsets
    
    //设置tabscrollview 最小间距
    func pageTabScrollviewMinSpace(_ pageView:YHPageViewController)->CGFloat
    

}
