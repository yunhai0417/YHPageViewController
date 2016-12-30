//
//  YHTabBarView.swift
//  YHPageView
//
//  Created by wuyunhai on 16/12/30.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

/*
 * TabBarView 导航栏view
 * 包含子控件 leftView:左边view
 *          rightView:右边view
 *          collectionview:中间滑动tabview
 *          BottomLine:下滑背景跟随lineView
 *          lineView:下划线
 */
class YHTabBarView: UIView {
    
    // IB
    fileprivate var rightView:UIView?
    fileprivate var leftView:UIView?
//    fileprivate var collectionview:UICollectionView?
    
    // porperty
    
    // weak
    weak var delegate:YHTabBarViewDelegate?
    weak var dataSource:YHTabBarViewDataSource?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("current YHTabBarView")
    }
    
    
    // MARK: open public func
    
    public func reloadDataSource(){
        
        YHTabBarViewConfigLeftView()
        
        
    }
    
    fileprivate func YHTabBarViewConfigLeftView(){
        guard let dataSource = dataSource else {
            return
        }
        
        if let leftView = leftView {
            leftView.removeFromSuperview()
        }
        leftView = nil
        if let view = dataSource.tabBarLeftView?(self) {
            leftView = view
            
        }
        
        if leftView != nil{
            self.addSubview(leftView!)
        }
    
    }
}
