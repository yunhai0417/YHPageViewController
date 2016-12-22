//
//  ViewController.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var statue:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController?.hidesBarsOnSwipe = true
        self.title = "title"
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func pageViewBtnAction(_ sender: Any) {
        let vc = CustomViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
        
       
        
       /* 
        if statue {
            self.navigationController?.navigationBar.isHidden = false
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            if !self.statue{
                self.navigationController?.navigationBar.frame = CGRect(x: 0, y:   -44, width: self.view.frame.size.width, height: 44)
            }else{
                self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20 , width: self.view.frame.size.width, height: 44)
            }
            
        }, completion: {Void in
            if !self.statue {
                self.navigationController?.navigationBar.isHidden = true
            }
            self.statue = !self.statue
        })
        */


}

