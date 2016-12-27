//
//  TableController.swift
//  YHPageView
//
//  Created by wuyunhai on 16/12/22.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class TableController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   

    var offSetY:CGFloat = 0
    var isFingerScrolling:Bool = false
    var pageIndex = 0
    var tableView:UITableView?
    weak var delegate: YHPageViewHIddenBarDelegate?

    //MARK: - Life cycles
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Will Appear :    \(pageIndex)")
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Did Appear :    \(pageIndex)")
        
        if (self.delegate?.currentNavBarSatue())! {
            tableView?.contentOffset.y = (tableView?.contentOffset.y)! + 44
        }
    }
    
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Will Disappear :    \(pageIndex)")
    }
    
     override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Did Disappear :    \(pageIndex)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    // Mark: UIScrollviewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetDelta = scrollView.contentOffset.y - offSetY
        offSetY = scrollView.contentOffset.y
        let scrollUp:Bool = offsetDelta > 0
        if !isFingerScrolling {
            return
        }
        self.delegate?.changeNavBarStatue(scrollView,scrollUp,offsetDelta)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offSetY = (tableView?.contentOffset.y)!
        isFingerScrolling = true
        //        if let temp = scrollviewBlock{
        //            temp(scrollView,"BeginDragging",(tableview.contentOffset.y))
        //        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        if let temp = scrollviewBlock{
        //            temp(scrollView,"WillEndDragging",0)
        //        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        if let temp = scrollviewBlock{
        //            temp(scrollView,"EndDecelerating",0)
        //        }
        isFingerScrolling = false
        
    }

}
