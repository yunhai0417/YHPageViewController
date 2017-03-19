//
//  CustomViewController.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class CustomViewController: YHPageViewController ,YHPageViewHIddenBarDelegate{

    var arrayname = [[String:String]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        let path = Bundle.main.path(forResource: "tabnames", ofType:"plist")
        // 加载 plist 文件
        arrayname = NSArray(contentsOfFile: path!) as! [[String : String]]
        for item in arrayname {
            if let name = item["name"] {
                print( name)
                
            }
            
            if let redhot = item["redhot"] {
                print( redhot)
                
            }
            
        }

        
        
        loadCurrentUI()
        self.showPageAtIndex(0, animated: true)
        

    }
    
    func rightBtnAction(_ sender:UIButton){
        print("xxx")
    }
    
    
    func changeNavBarStatue(_ scrollview:UIScrollView, _ isHidden: Bool, _ currentOffset: CGFloat) {
        
        guard let pageTabView = pageTabView else {
            return
        }
        
        guard let pageTabScrollview = pageTabScrollview else {
            return
        }
        
        let tempTopY = pageTabView.frame.origin.y - currentOffset
        if isHidden{
            let topViewDelta:CGFloat = 64
            let scrollViewDelta = scrollview.contentOffset.y + 44
            let delta = topViewDelta - scrollViewDelta
            if delta < 0 {
                if tempTopY <= 20{
                    pageTabView.frame.origin.y = 20
                    pageTabScrollview.frame.origin.y = 20
                }else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.pageTabView?.frame.origin.y = 20
                        self.pageTabScrollview?.frame.origin.y = 20
                    })
                }
            }
            
        }else{
            
            if pageTabView.frame.origin.y >= CGFloat(64) {
                pageTabView.frame.origin.y = 64
                pageTabScrollview.frame.origin.y = 64
            }else if pageTabScrollview.frame.origin.y - currentOffset <= 64 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.pageTabView?.frame.origin.y = 64
                    self.pageTabScrollview?.frame.origin.y = 64
                })
                
            }else {
                pageTabView.frame.origin.y = 64
                pageTabScrollview.frame.origin.y = 64
            }
            
            
        }
    }
    
    func currentNavBarSatue() -> Bool {
        if pageTabView?.frame.origin.y ==  20 {
            return true
        }
        return false
    }
    
   
}


extension CustomViewController{
    
    override func pageScrollviewWillShow(_ fromIndex: Int, toIndex: Int, animated: Bool) {
        
    }
    
    override func pageScrollviewDidShow(_ fromIndex: Int, toIndex: Int, finished: Bool) {
        
    }
    
    override func pageScrollview(_ pageViewController: YHPageViewController, willTransitonFrom fromVC: UIViewController, toViewController toVC: UIViewController) {
    }
    
    override func pageScrollview(_ pageViewController: YHPageViewController, didTransitonFrom fromVC: UIViewController, toViewController toVC: UIViewController) {
        
    }
    
    override func pageScrollview(_ pageViewController: YHPageViewController, didLeaveViewController fromVC: UIViewController, toViewController toVC: UIViewController, finished: Bool) {
        
    }
    
    override func pageScrollview(_ pageViewController: YHPageViewController, willLeaveViewController fromVC: UIViewController, toViewController toVC: UIViewController, animated: Bool) {
        
    }
}


extension CustomViewController {
    
    
    override func numberOfControllers(_ pageView: YHPageViewController) -> Int {
        return arrayname.count
    }
    
    override func pageView(_ pageView:YHPageViewController,titleAtIndex index:Int) -> String{
        if let name = arrayname[index]["name"] {
                return name
        }
        return ""
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
//        return nil
    }
    
    override func pageView(_ pageView: YHPageViewController, controllerAtIndex index: Int) -> UIViewController {
        
        let vc = TableController()
        vc.pageIndex = index
        vc.delegate = self
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

