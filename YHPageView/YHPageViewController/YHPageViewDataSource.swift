//
//  YHPageViewDataSource.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

protocol YHPageViewDataSource : class {
    
    
    
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

extension YHPageViewController{
    // MARK: YHPageViewDataSource
    func pageView(_ pageView: YHPageViewController, controllerAtIndex index: Int) -> UIViewController {
        return UIViewController()
    }
    
    func numberOfControllers(_ pageView: YHPageViewController) -> Int {
        return 0
    }
    
    func pageTabRightView(_ pageView: YHPageViewController) -> UIView? {
        return nil
    }
    
    
    func pageViewTopSize(_ pageView: YHPageViewController) -> CGRect {
        let screenBounds:CGRect = UIScreen.main.bounds
        return CGRect(x: 0,
                      y: 0,
                      width: screenBounds.size.width,
                      height: 44)
    }
    
    func pageScrollViewSize(_ pageView: YHPageViewController) -> CGRect {
        let screenBounds:CGRect = UIScreen.main.bounds
        return CGRect(x: 0,
                      y: 0,
                      width: screenBounds.size.width,
                      height: screenBounds.size.height)
    }
    
    
    func pageView(_ pageView: YHPageViewController, titleAtIndex index: Int) -> String {
        return "title\(index)"
    }
    
    func pageView(_ pageView: YHPageViewController, titlespaceAtIndex index: Int) -> CGFloat {
        return 18
    }
    
    
    func pageView(_ pageView: YHPageViewController, titleFontAtIndex index: Int) -> UIFont {
        return UIFont(name: "Symbol", size: 16)!
    }
    
    func pageTabScrollview(_ pageView: YHPageViewController) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    func pageTabScrollviewMinSpace(_ pageView: YHPageViewController) -> CGFloat {
        return 20
    }
    
    func pageTabScrollview(_ pageView: YHPageViewController, buttonAtIndex index: Int) -> UIButton {
        
        return UIButton()
    }

}

