//
//  CustomPageViewCell.swift
//  YHPageView
//
//  Created by 吴云海 on 17/3/20.
//  Copyright © 2017年 吴云海. All rights reserved.
//

import UIKit

class CustomPageViewCell: YHPageViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        celllabel.text = "xxxxxx"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
