//
//  YHPageViewCell.swift
//  YHPageView
//
//  Created by 吴云海 on 17/3/20.
//  Copyright © 2017年 吴云海. All rights reserved.
//

import UIKit

class YHPageViewCell: UIView {
    @IBOutlet var celllabel: UILabel!

    func loadViewFfromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(view)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFfromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
