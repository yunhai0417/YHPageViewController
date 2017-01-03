//
//  YHTabBarViewItem.swift
//  YHPageView
//
//  Created by wuyunhai on 17/1/3.
//  Copyright © 2017年 吴云海. All rights reserved.
//  滑动的item

import UIKit

class YHTabBarViewItem: UICollectionViewCell {
    
    var itemLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        itemLabel?.font = UIFont(name: "Optima", size: 16)
        itemLabel?.textAlignment = .center
        itemLabel?.backgroundColor = UIColor.clear
        self.contentView.addSubview(itemLabel!)
        self.contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
