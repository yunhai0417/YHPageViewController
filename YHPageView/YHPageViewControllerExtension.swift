//
//  YHPageViewControllerExtension.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/19.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

extension YHPageViewController{
    func yhaddChildViewController(_ viewController:UIViewController){
        yhaddChildViewController(viewController, frame: self.view.bounds)
    }
    
    func yhaddChildViewController(_ viewController:UIViewController,inView:UIView,withFrame:CGRect){
        for vcItem in self.childViewControllers{
            if vcItem.view.tag == viewController.view.tag{
                return
            }
        }
        
        yhaddChildViewController(viewController, setSubViewAction: {(superViewController,childViewController) in
            childViewController.view.frame = withFrame
            
            if inView.subviews.contains(viewController.view) == false{
                inView.addSubview(viewController.view)
            }
        
        })
    
    }

    func yhaddChildViewController(_ viewController:UIViewController,frame:CGRect){
        yhaddChildViewController(viewController, setSubViewAction: {(superViewController,childViewController) in
            childViewController.view.frame = frame;
            
            if superViewController.view.subviews.contains(viewController.view) == false {
                superViewController.view.addSubview(viewController.view)
            }
            
        })
    
    }
    
    
    func yhaddChildViewController(_ viewController:UIViewController,setSubViewAction:((_ superViewController:UIViewController,_ childViewController:UIViewController) -> Void)?){
        let containsVC = self.childViewControllers.contains(viewController)
        
        if containsVC == false{
            self.addChildViewController(viewController)
        }
        
        if let temp =  setSubViewAction{
            temp(self,viewController)
        }
        
        if containsVC == false {
            viewController.didMove(toParentViewController: self)
        }
    
    }
}
