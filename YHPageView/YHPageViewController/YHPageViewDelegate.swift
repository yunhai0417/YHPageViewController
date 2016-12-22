//
//  YHPageViewDelegate.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

@objc protocol YHPageViewDelegate : class{
    
    func pageScrollviewWillShow(_ fromIndex:Int ,toIndex:Int, animated:Bool)
    
    func pageScrollviewDidShow(_ fromIndex:Int ,toIndex:Int, finished:Bool)
    
    func pageScrollview(_ pageViewController:YHPageViewController,willTransitonFrom fromVC:UIViewController,toViewController toVC:UIViewController)
    
    func pageScrollview(_ pageViewController:YHPageViewController,didTransitonFrom fromVC:UIViewController,toViewController toVC:UIViewController)
    
    func pageScrollview(_ pageViewController: YHPageViewController,
                        didLeaveViewController fromVC:UIViewController,
                        toViewController toVC:UIViewController,
                        finished:Bool)
    
    func pageScrollview(_ pageViewController: YHPageViewController,
                        willLeaveViewController fromVC:UIViewController,
                        toViewController toVC:UIViewController,
                        animated:Bool)
    
}
