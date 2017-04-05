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
        
//        let viewcell = YHPageViewCell(frame: CGRect(x: 100, y: 100, width: 200, height: 44))
//        self.view.addSubview(viewcell)
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

