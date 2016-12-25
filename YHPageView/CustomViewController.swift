//
//  CustomViewController.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class CustomViewController: YHPageViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        
        
        
        loadCurrentUI()
        self.showPageAtIndex(0, animated: true)
        

    }
    

    
    override func numberOfControllers(_ pageView: YHPageViewController) -> Int {
        return 11
    }
    
  
    
    override func pageTabRightView(_ pageView: YHPageViewController) -> UIView? {
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
    
    
    override func pageView(_ pageView: YHPageViewController, controllerAtIndex index: Int) -> UIViewController {
        
        let colorStep:CGFloat = 1/4
        let vc = TableController()
        vc.pageIndex = index
        vc.view.backgroundColor = UIColor(red: colorStep * CGFloat((index + 1) % 2), green: colorStep * CGFloat((index + 1)  % 3), blue: colorStep * CGFloat((index + 1)  % 5), alpha: 1)
        return vc
    }
    
    
    override func pageViewTopSize(_ pageView: YHPageViewController) -> CGRect {
        return CGRect(x: 0, y: 64, width: view.frame.size.width, height: 44)
    }
    
    override func pageScrollViewSize(_ pageView: YHPageViewController) -> CGRect {
        let screenBounds:CGRect = UIScreen.main.bounds
        return CGRect(x: 0, y: 64, width: screenBounds.size.width, height: screenBounds.size.height - 64)
    }
    
}
