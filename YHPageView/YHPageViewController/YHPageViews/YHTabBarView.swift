//
//  YHTabBarView.swift
//  YHPageView
//
//  Created by wuyunhai on 16/12/30.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

/*
 * TabBarView 导航栏view
 * 包含子控件 leftView:左边view
 *          rightView:右边view
 *          collectionview:中间滑动tabview
 *          BottomLine:下滑背景跟随lineView
 *          lineView:下划线
 */
class YHTabBarView: UIView
    ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // IB
    fileprivate var rightView:UIView?
    fileprivate var leftView:UIView?
    fileprivate var collectionview:UICollectionView?
    fileprivate var barscrollView:UIScrollView?
    fileprivate var bottomLineView:UIView?
    
    // porperty
    fileprivate var selectIndex:Int = Int.max
    
    // weak
    weak var delegate:YHTabBarViewDelegate?
    weak var dataSource:YHTabBarViewDataSource?
    
    //public 共有属性  背景色
    public var tabViewBackgroundColor = UIColor.white
    public var lineBottomColor = UIColor(red: 4/255.0, green: 157/255.0, blue: 234/255.0, alpha: 1.0)
    public var lineBottomHeight:CGFloat = 2
    public var titlesMinSpace:CGFloat = 18   //文字左右空白
    public var ItemSelectedColor = UIColor(red: 4/255.0, green: 157/255.0, blue: 234/255.0, alpha: 1.0)     //选择颜色
    public var ItemUnSelectedColor = UIColor(red: 84/255.0, green: 90/255.0, blue: 97/255.0, alpha: 1.0)    //未选择颜色
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit current YHTabBarView")
    }
    
    
    // MARK: open public func
    
    public func reloadDataSource(){
        
        YHTabBarViewConfigLeftView()
        YHTabBarViewConfigRightView()
        YHTabBarViewScrollView()
        YHTabBarViewCollectionView()
        YHTabBarBottomLineView()
    }
    //加载leftView
    fileprivate func YHTabBarViewConfigLeftView(){
        guard let dataSource = dataSource else {
            return
        }
        //添加左边位置
        if let leftView = leftView {
            leftView.removeFromSuperview()
        }
        leftView = nil
        if let view = dataSource.tabBarLeftView(self) {
            leftView = view
        }
        
        if let leftView = leftView{
            leftView.frame = CGRect(x: 0, y: 0, width: leftView.frame.size.width, height: self.frame.size.height)
            self.addSubview(leftView)
        }
        
        
    }
    // Mark: loading rightView
    fileprivate func YHTabBarViewConfigRightView(){
        guard let dataSource = dataSource else {
            return
        }
        //添加右边位置
        if let rightView = rightView{
            rightView.removeFromSuperview()
        }
        rightView = nil
        
        if let view = dataSource.tabBarRightView(self){
            rightView = view
        }
        
        if let rightView = rightView{
            rightView.frame = CGRect(x: self.frame.size.width - rightView.frame.size.width, y: 0, width: rightView.frame.size.width, height: self.frame.size.height)
            self.addSubview(rightView)
        }
    }
    
    // Mark: loading collectionview
    fileprivate func YHTabBarViewCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var leftsize:CGFloat = 0
        if let leftView = leftView{
            leftsize = leftView.frame.size.width
        }
        var rightsize:CGFloat = 0
        if let rightView = rightView{
            rightsize = rightView.frame.size.width
        }
        
        collectionview = UICollectionView(frame: CGRect(x: leftsize, y: 0, width: self.frame.size.width - leftsize - rightsize, height: self.frame.size.height), collectionViewLayout: layout)
        collectionview?.backgroundColor = UIColor.clear
        collectionview?.delegate = self
        collectionview?.dataSource = self
        collectionview?.showsHorizontalScrollIndicator = false        
        self.addSubview(collectionview!)
    
        collectionview?.register(YHTabBarViewItem.self, forCellWithReuseIdentifier: "YHTabBarItem")

    }
    // MARK: loading ScrollView
    fileprivate func YHTabBarViewScrollView(){
        
        var leftsize:CGFloat = 0
        if let leftView = leftView{
            leftsize = leftView.frame.size.width
        }
        var rightsize:CGFloat = 0
        if let rightView = rightView{
            rightsize = rightView.frame.size.width
        }
        
        barscrollView = UIScrollView(frame: CGRect(x: leftsize, y: 0, width: self.frame.size.width - leftsize - rightsize, height: self.frame.size.height))
        barscrollView?.backgroundColor = UIColor.cyan
        self.addSubview(barscrollView!)
    }
    // MARK: loading BottomLineView
    fileprivate func YHTabBarBottomLineView(){
        bottomLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - lineBottomHeight, width: 0, height: lineBottomHeight))
        bottomLineView?.backgroundColor = ItemSelectedColor
        barscrollView?.addSubview(bottomLineView!)
        barscrollView?.contentSize = (collectionview?.contentSize)!
    }
}

// MARK: UICollectionView delegate datasource layoutDelegate
extension YHTabBarView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YHTabBarItem", for: indexPath) as? YHTabBarViewItem {
            cell.itemLabel?.text = "xxxxxx \(indexPath.row)"
            cell.itemLabel?.textColor = ItemUnSelectedColor
            if indexPath.row == selectIndex {
                cell.itemLabel?.textColor = ItemSelectedColor
            }
            return cell
        }
        
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YHTabBarViewItem{
                cell.itemLabel?.textColor = ItemSelectedColor
            
//            print(collectionView.convert(cell.frame, to: collectionView))
            print(collectionView.convert(cell.frame, to: self))
//            print(collectionView.frame)
            //矫正 collectionviewcell 在屏幕中的相对位置 self.frame.size.wigth / 2 = x + cell.frame.size.wight / 2
            let rectCell = collectionView.convert(cell.frame, to: collectionView)
            let offset = rectCell.origin.x + rectCell.size.width / 2
            
            
            
            
            if offset < collectionView.frame.size.width / 2 {
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else if  offset + collectionView.frame.size.width / 2 < collectionView.contentSize.width {
                collectionView.setContentOffset(CGPoint(x: offset - collectionView.frame.size.width / 2, y: 0), animated: true)
            }else{
                collectionView.setContentOffset(CGPoint(x: collectionView.contentSize.width - collectionView.frame.size.width , y: 0), animated: true)
            }
            
            
           
           
           
            
        }
        
        
        if let cell = collectionView.cellForItem(at: indexPath) as? YHTabBarViewItem{
        let rectView = collectionView.convert(cell.frame, to: self.barscrollView)
            print(collectionView.convert(cell.frame, to: self))

        UIView.animate(withDuration: 0.2, animations:{
            if let bottomLineView = self.bottomLineView {
                bottomLineView.frame = CGRect(x: rectView.origin.x, y: self.frame.size.height - self.lineBottomHeight, width: rectView.size.width, height:self.lineBottomHeight)
            }
        }, completion: {Void in
        })
        }
        selectIndex = indexPath.row
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YHTabBarViewItem{
            cell.itemLabel?.textColor = ItemUnSelectedColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


extension YHTabBarView {
    

}
