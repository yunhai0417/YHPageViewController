//
//  ViewController.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var arrayname:[[String:String]]?
    fileprivate var statue:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController?.hidesBarsOnSwipe = true
        self.title = "title"
        self.navigationController?.navigationBar.isTranslucent = false
        
        let path = Bundle.main.path(forResource: "tabnames", ofType:"plist")
        
        // 加载 plist 文件
        arrayname = NSArray(contentsOfFile: path!) as! [[String : String]]?
        
        for item in arrayname! {
            if let name = item["name"] {
                print( name)

            }
            
            if let redhot = item["redhot"] {
                print( redhot)
                
            }

        }
    }
    
    @IBAction func pageViewBtnAction(_ sender: Any) {
        let vc = CustomViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

