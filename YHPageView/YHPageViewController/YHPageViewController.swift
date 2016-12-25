//
//  YHPageViewController.swift
//  YHPageView
//
//  Created by 吴云海 on 16/12/18.
//  Copyright © 2016年 吴云海. All rights reserved.
//

import UIKit

class YHPageViewController: UIViewController,
    UIScrollViewDelegate,NSCacheDelegate
    ,YHPageViewDelegate,YHPageViewDataSource
{
    weak var delegate:YHPageViewDelegate?
    weak var dataSource:YHPageViewDataSource?
    
    //MARK:IB
    fileprivate var pageTabView:UIView?
    fileprivate var pageTabScrollview:UIScrollView?
    fileprivate var pageScrollview:UIScrollView?
    fileprivate var lineBottom:UIView?  //游标
    
    
    
    //MARK:-properties
    fileprivate var topTabScrollViewWidth:CGFloat = 0
    fileprivate var rightButtonWidth:CGFloat = 0    //右边按钮宽度
    fileprivate var _currentIndex:Int = 0           // 当前位置下标
    fileprivate var _lastSelectedIndex = 0          // 用于记录上次选择的index
    fileprivate var originOffset = 0.0                  //用于手势拖动scrollView时，判断方向
    fileprivate var guessToIndex = -1                   //用于手势拖动scrollView时，判断要去的页面
    fileprivate var _centerPoints:[CGFloat]?
    fileprivate var _width_k_array:[CGFloat] = [CGFloat]()
    fileprivate var _width_b_array:[CGFloat] = [CGFloat]()
    fileprivate var _point_k_array:[CGFloat] = [CGFloat]()
    fileprivate var _point_b_array:[CGFloat] = [CGFloat]()
    fileprivate var childsToClean = Set<UIViewController>()
    
    fileprivate var titleSizeArray:[CGRect] = [CGRect]()

    
    fileprivate var firstWillAppear = true              //用于界定页面首次WillAppear。
    fileprivate var firstDidAppear = true               //用于界定页面首次DidAppear。
    fileprivate var firstDidLayoutSubViews = true       //用于界定页面首次DidLayoutsubviews。
    fileprivate var firstWillLayoutSubViews = true      //用于界定页面首次WillLayoutsubviews。
    fileprivate var isDecelerating = false              //正在减速操作
    fileprivate var isTabClick = false                  //点击事件开启
    
    //public 共有属性  背景色
    public var tabViewBackgroundColor = UIColor.white
    public var lineBottomColor = UIColor(red: 4/255.0, green: 157/255.0, blue: 234/255.0, alpha: 1.0)
    public var lineBottomHeight:CGFloat = 2
    public var titlesMinSpace:CGFloat = 18   //文字左右空白
    public var pageSelectedColor = UIColor(red: 4/255.0, green: 157/255.0, blue: 234/255.0, alpha: 1.0)     //选择颜色
    public var pageUnSelectedColor = UIColor(red: 84/255.0, green: 90/255.0, blue: 97/255.0, alpha: 1.0)    //未选择颜色


    
    fileprivate var pageCount:Int {
        get {
            if let dataSource = dataSource{
                return dataSource.numberOfControllers(self)
            }
            return 0
        }
    }
    
    fileprivate lazy var memCache:NSCache<NSNumber, UIViewController> = {
        let cache = NSCache<NSNumber, UIViewController>()
        cache.countLimit = 3
        return cache
    }()
    var cacheLimit:Int {
        get {
            return self.memCache.countLimit
        }
        set {
            self.memCache.countLimit = newValue;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.delegate = self
        self.dataSource = self
        self.memCache.delegate = self
        //load CurrentUI
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        if firstWillAppear {
            if let delegate = delegate {
                delegate.pageScrollviewWillShow(_lastSelectedIndex, toIndex: _currentIndex, animated: false)
                
                delegate.pageScrollview(self, willTransitonFrom: controllerAtIndex(_lastSelectedIndex),
                                        toViewController: controllerAtIndex(_currentIndex))
            }
            firstWillAppear = false
        }
        //获取vc 触发生命周期
        controllerAtIndex(_currentIndex).beginAppearanceTransition(true, animated: true)
    }
    
    deinit {
        print("YHPageViewController deinit")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstDidLayoutSubViews {
            
            firstDidLayoutSubViews = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstDidAppear {
            firstDidAppear = false
            if let delegate = delegate{
                delegate.pageScrollviewDidShow(_lastSelectedIndex, toIndex: _currentIndex, finished: true)
                delegate.pageScrollview(self, didLeaveViewController: controllerAtIndex(_lastSelectedIndex), toViewController: controllerAtIndex(_currentIndex), finished: true)
            }
        }
        controllerAtIndex(_currentIndex).endAppearanceTransition()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controllerAtIndex(_currentIndex).beginAppearanceTransition(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        controllerAtIndex(_currentIndex).endAppearanceTransition()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.memCache.removeAllObjects()
    }
    
    //MARK: - Update controllers & views
    func showPageAtIndex(_ index:Int,animated:Bool){
        if index < 0 || index >= self.pageCount {
            return
        }
        // Synchronize the indexs and store old select index
        let oldSelectedIndex = _lastSelectedIndex
        _lastSelectedIndex = _currentIndex
        currentIndex = index
        // Prepare to scroll if scrollView is initialized and displayed correctly
        if let pageScrollview = pageScrollview , pageScrollview.frame.size.width > 0.0  && pageScrollview.contentSize.width > 0.0{
            if let dalegate = delegate{
                dalegate.pageScrollviewWillShow(_lastSelectedIndex, toIndex: _currentIndex, animated: animated)
                dalegate.pageScrollview(self, willLeaveViewController: controllerAtIndex(_lastSelectedIndex), toViewController: controllerAtIndex(_currentIndex), animated: animated)
                //添加即将显示vc
                addVisibleViewContorllerWith(_currentIndex)
            }
        }
        
        // Scroll to current index if scrollView is initialized and displayed correctly
        guard  let pageScrollview = pageScrollview else {
            return
        }
        
        if pageScrollview.frame.size.width > 0.0  && pageScrollview.contentSize.width > 0.0{
            // Aciton closure before simulated scroll animation
            let scrollBeginAnimation = { [weak self] in
                if let strongSelf = self {
                strongSelf.controllerAtIndex(strongSelf._currentIndex).beginAppearanceTransition(true, animated: animated)
                    if strongSelf._currentIndex != strongSelf._lastSelectedIndex {
                        strongSelf.controllerAtIndex(strongSelf._lastSelectedIndex).beginAppearanceTransition(false, animated: animated)
                    }
                }
                
            }
            
            /* Scroll closure invoke setContentOffset with animation false. Because the scroll animation is customed.
             *
             * Simulate scroll animation among oldSelectView, lastView and currentView.
             * After simulated animation the scrollAnimation closure is invoked
             */
            let scrollAnimation = { [weak self] in
                if let strongSelf = self {

                    pageScrollview.setContentOffset(strongSelf.calcOffsetWithIndex(
                    strongSelf._currentIndex,
                    width:pageScrollview.frame.size.width,
                    maxWidth:pageScrollview.contentSize.width), animated: false)
                }
            }
            
            
            // Action closure after simulated scroll animation
            
            let scrollEndAnimation = { [weak self] in
                if let strongSelf = self {
                    strongSelf.controllerAtIndex(strongSelf._currentIndex).endAppearanceTransition()
                    if strongSelf._currentIndex != strongSelf._lastSelectedIndex {
                        strongSelf.controllerAtIndex(strongSelf._lastSelectedIndex).endAppearanceTransition()
                    }
                    if let delegate = strongSelf.delegate{
                        delegate.pageScrollviewDidShow(strongSelf._lastSelectedIndex, toIndex: strongSelf._currentIndex, finished: animated)
                        delegate.pageScrollview(strongSelf, didLeaveViewController: strongSelf.controllerAtIndex(strongSelf._lastSelectedIndex), toViewController: strongSelf.controllerAtIndex(strongSelf._currentIndex), finished: animated)
                    }
                    strongSelf.cleanCacheToClean()
                
                }
                
            }
            
            
            
            
            scrollBeginAnimation()
            //scrollview 滚动
            if animated{
                if _lastSelectedIndex != _currentIndex {
                    let pageSize = pageScrollview.frame.size
                    let direction = (_lastSelectedIndex < _currentIndex) ? YHPageScrollDirection.right : YHPageScrollDirection.left
                    let lastView:UIView = self.controllerAtIndex(_lastSelectedIndex).view
                    let currentView:UIView = self.controllerAtIndex(_currentIndex).view
                    let oldSelectView:UIView = self.controllerAtIndex(oldSelectedIndex).view
                    let duration = 0.3
                    
                    let backgroundIndex = self.calcIndexWithOffset(pageScrollview.contentOffset.x,
                                                                   width: pageScrollview.frame.size.width)
                    var backgroundView:UIView?
                    
                    /*
                     *  To solve the problem: when multiple animations were fired, there is an extra unuseful view appeared under the scrollview's two subviews(used to simulate animation: lastView, currentView).
                     *
                     *  Hide the extra view, and after the animation is finished set its hidden property false.
                     */
                    //判断CALayer正在做动画
                    if let oldanimationKeys = oldSelectView.layer.animationKeys(),oldanimationKeys.count > 0, let lastanimationKeys = lastView.layer.animationKeys() ,lastanimationKeys.count > 0 {
                        
                        let tmpView = self.controllerAtIndex(backgroundIndex).view
                        if tmpView != currentView &&
                            tmpView != lastView
                        {
                            backgroundView = tmpView
                            backgroundView?.isHidden = true
                        }
                    }
                    
                    // Cancel animations is not completed when multiple animations are fired
                    pageScrollview.layer.removeAllAnimations()
                    oldSelectView.layer.removeAllAnimations()
                    lastView.layer.removeAllAnimations()
                    currentView.layer.removeAllAnimations()
                    // oldSelectView is not useful for simulating animation, move it to origin position.
                    self.moveBackToOriginPositionIfNeeded(oldSelectView, index: oldSelectedIndex)
                    // Bring the views for simulating scroll animation to front and make them visible
                    pageScrollview.bringSubview(toFront: lastView)
                    pageScrollview.bringSubview(toFront: currentView)
                    lastView.isHidden = false
                    currentView.isHidden = false
                    
                    // Calculate start positions , animate to positions , end positions for simulating animation views(lastView, currentView)
                    let lastView_StartOrigin = lastView.frame.origin
                    var currentView_StartOrigin = lastView.frame.origin
                    if direction == .right {
                        currentView_StartOrigin.x += pageScrollview.frame.size.width
                    } else {
                        currentView_StartOrigin.x -= pageScrollview.frame.size.width
                    }
                    
                    var lastView_AnimateToOrigin = lastView.frame.origin
                    if direction == .right {
                        lastView_AnimateToOrigin.x -= pageScrollview.frame.size.width
                    } else {
                        lastView_AnimateToOrigin.x += pageScrollview.frame.size.width
                    }
                    let currentView_AnimateToOrigin = lastView.frame.origin
                    
                    let lastView_EndOrigin = lastView.frame.origin
                    let currentView_EndOrigin = currentView.frame.origin
                    
                    /*
                     *  Simulate scroll animation
                     *  Bring two views(lastView, currentView) to front and simulate scroll in neighbouring position.
                     */
                    
                    lastView.frame = CGRect(x: lastView_StartOrigin.x, y: lastView_StartOrigin.y, width: pageSize.width, height: pageSize.height)
                
                    currentView.frame = CGRect(x: currentView_StartOrigin.x, y: currentView_StartOrigin.y, width: pageSize.width, height: pageSize.height)
                  
                    UIView.animate(withDuration: duration,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions(),
                                   animations:
                        {
                            lastView.frame = CGRect(x: lastView_AnimateToOrigin.x , y: lastView_AnimateToOrigin.y, width: pageSize.width, height: pageSize.height)
                            currentView.frame = CGRect(x: currentView_AnimateToOrigin.x , y: currentView_AnimateToOrigin.y, width: pageSize.width, height: pageSize.height)
                           
                    },completion:{ [weak self] (finished) in
                            if finished {
                                lastView.frame = CGRect(x: lastView_EndOrigin.x, y: lastView_EndOrigin.y, width: pageSize.width, height: pageSize.height)
                                currentView.frame = CGRect(x: currentView_EndOrigin.x, y: currentView_EndOrigin.y, width: pageSize.width, height: pageSize.height)
                                backgroundView?.isHidden = false
                                if let weakSelf = self {
                                   weakSelf.moveBackToOriginPositionIfNeeded(currentView, index: weakSelf._currentIndex)
                                   weakSelf.moveBackToOriginPositionIfNeeded(lastView, index: weakSelf._lastSelectedIndex)
                                }
                                scrollAnimation()
                                scrollEndAnimation()
                            }
                        })
                    
                }else{
                    // Scroll without animation if current page is the same with last page
                    scrollAnimation()
                    scrollEndAnimation()
                    
                }
            }else{
                // Scroll without animation if animated is false
                scrollAnimation()
                scrollEndAnimation()
            }
            
        }
        
    }
    
    
    //MARK: - Helper methods
    fileprivate func calcOffsetWithIndex(_ index:Int,width:CGFloat,maxWidth:CGFloat) -> CGPoint {
        var offsetX = CGFloat(CGFloat(index) * width)
        
        if offsetX < 0 {
            offsetX = 0
        }
        
        if maxWidth > 0.0 &&
            offsetX > maxWidth - width
        {
            offsetX = maxWidth - width
        }
        
        return CGPoint(x: CGFloat(offsetX),y: 0)
    }
    
    fileprivate func calcIndexWithOffset(_ offset:CGFloat,width:CGFloat) -> Int {
        var startIndex = Int(offset/width)
        
        if startIndex < 0 {
            startIndex = 0
        }
        return startIndex
    }
    
    
    fileprivate func moveBackToOriginPositionIfNeeded(_ view:UIView?,index:Int)
    {
        if index < 0 || index >= self.pageCount {
            return
        }
        
        guard let destView = view else { print("moveBackToOriginPositionIfNeeded view nil"); return;}
        guard let pageScrollview = pageScrollview else{ return }
        
        let originPosition = self.calcOffsetWithIndex(index,
                                                      width: pageScrollview.frame.size.width,
                                                      maxWidth: pageScrollview.contentSize.width)
        if destView.frame.origin.x != originPosition.x {
            var newFrame = destView.frame
            newFrame.origin = originPosition
            destView.frame = newFrame
        }
    }
    
    
    
    //返回vc 在scrollview中的位置
    fileprivate func calcVisibleViewControllerFrameWith(_ index:Int) -> CGRect {
        if let pageScrollview = pageScrollview{
            var offsetX = 0.0
            offsetX = Double(index) * Double(pageScrollview.frame.size.width)
            return CGRect(x: CGFloat(offsetX), y: 0, width: pageScrollview.frame.size.width, height: pageScrollview.frame.size.height)
            
        }
        return CGRect.zero
    }
    
    // 添加即将显示的vc
    fileprivate func addVisibleViewContorllerWith(_ index:Int){
        if index < 0 || index > self.pageCount {
            return
        }
        
        
        
        var vc:UIViewController? = self.memCache.object(forKey: NSNumber(value: index))
        if vc == nil {
            vc = self.controllerAtIndex(index)
            vc?.view.tag = index + 10
        }
        let childViewFrame = calcVisibleViewControllerFrameWith(index)
        if let pageScrollview = pageScrollview {
            yhaddChildViewController(vc!, inView: pageScrollview, withFrame: childViewFrame)
            
        }
        
        self.memCache.setObject(self.controllerAtIndex(index), forKey: NSNumber(value: index))
        
        
        
    }
    
    // 获取当前的vc
    fileprivate func controllerAtIndex(_ index:Int) ->UIViewController{
        for vcItem in self.childViewControllers{
            if vcItem.view.tag == index + 10{
                return vcItem
            }
        }
        
        if let dataSource = dataSource{
            return dataSource.pageView(self, controllerAtIndex: index)
        }
        return UIViewController()
    }
    
    fileprivate func cleanCacheToClean() {
        let currentPage = self.controllerAtIndex(_currentIndex)
        if self.childsToClean.contains(currentPage) {
            if let removeIndex = self.childsToClean.index(of: currentPage) {
                self.childsToClean.remove(at: removeIndex)
                self.memCache.setObject(currentPage, forKey: NSNumber(value: _currentIndex))
            }
        }
        
        for vc in self.childsToClean {
            //            print("-21-  clean cache index \((vc as! TestChildViewController).pageIndex)")
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
        self.childsToClean.removeAll()
        
        //        print("-31- remain111 ==============================>")
        //        for vcc in self.childViewControllers {
        //            print("remain \((vcc as! TestChildViewController).pageIndex)")
        //        }
        //        print("-31- remain111 ==============================>")
    }
    
    
    
    // MARK: loadCurrentUI  加载当前UI
    func loadCurrentUI(){
        if let _pageScrollview = _pageScrollview{
            view.addSubview(_pageScrollview)
        }
        
        if let _pageTabView = _pageTabView {
            view.addSubview(_pageTabView)
        }
        
        if let _pageTabScrollview = _pageTabScrollview{
            view.addSubview(_pageTabScrollview)
        }
        
    }
    
    
    fileprivate var _pageScrollview:UIScrollView?{
        get{
            if pageScrollview == nil {
                pageScrollview = UIScrollView()
            }
            if let dataSource = dataSource{
            pageScrollview?.frame = dataSource.pageScrollViewSize(self)
            pageScrollview?.delegate = self
            pageScrollview?.backgroundColor = UIColor.white

            
                let count = dataSource.numberOfControllers(self)
                pageScrollview?.contentSize = CGSize(width: view.frame.width * CGFloat(count), height: 0)
                
            }
            pageScrollview?.isPagingEnabled = true
            pageScrollview?.showsHorizontalScrollIndicator = false
            
            return pageScrollview
        }
        
        
    }
    
    
    fileprivate var _pageTabView:UIView?{
        get{
            if pageTabView == nil {
                if let dataSource = self.dataSource{
                    pageTabView = UIView(frame: dataSource.pageViewTopSize(self))
                }
            }
            if let pageTabView = pageTabView{
                    pageTabView.backgroundColor = tabViewBackgroundColor

                if let rightView = dataSource?.pageTabRightView(self) {
                    let rightviewsize = rightView.bounds.size.width / 2
                    pageTabView.addSubview(rightView)
                    rightView.center = CGPoint(x: pageTabView.frame.width - rightviewsize,
                                               y: pageTabView.frame.size.height / 2)
                }
                

            }
            
            return pageTabView
        }
    }
    
    fileprivate var _pageTabScrollview:UIScrollView?{
        get{
            if let pageTabView = pageTabView{
                if let dataSource = dataSource{
                    
                    if let rightView = dataSource.pageTabRightView(self){
                        
                        rightButtonWidth = rightView.bounds.size.width
                        topTabScrollViewWidth = pageTabView.frame.width - rightButtonWidth
                    }
                    pageTabScrollview = UIScrollView()
                    pageTabScrollview?.frame = CGRect(x: 0, y: pageTabView.frame.origin.y, width: topTabScrollViewWidth, height: pageTabView.frame.size.height)
                    pageTabScrollview?.showsHorizontalScrollIndicator = false
                    pageTabScrollview?.alwaysBounceHorizontal = true
                    
                    // setting pageTabScrollview content 设置 pageTabScrollview 内容
                    // 计算文字宽度 + 添加文字边距
                    var totalWidth:CGFloat = 0
                    var equalX:CGFloat = dataSource.pageTabScrollview(self).left
                    var equalIntervals:[CGFloat] = [CGFloat]()
                    var averageX:CGFloat = dataSource.pageTabScrollview(self).left
                    
                    var minWidth:CGFloat = 1
                    
                    for index in 0 ..< dataSource.numberOfControllers(self){
                        let str = dataSource.pageView(self, titleAtIndex: index)
                        var titleSize:CGRect = self.getStringRectSize(str,CGSize(width: 999, height:pageTabView.frame.height),index)
                        titleSize.size.width += titlesMinSpace * 2.0
                        totalWidth += ceil(titleSize.size.width)
                        titleSizeArray.append(titleSize)
                        equalIntervals.append(equalX + titleSize.width/2)
                        equalX = equalX + dataSource.pageTabScrollviewMinSpace(self) + CGFloat(ceil(titleSize.size.width))
                    }
                    minWidth = (topTabScrollViewWidth - totalWidth) / CGFloat(dataSource.numberOfControllers(self) + 1)
                    averageX = minWidth
                    
                    var averageIntervals:[CGFloat] = [CGFloat]()
                    for index in 0 ..< dataSource.numberOfControllers(self){
                        averageIntervals.append(averageX + (titleSizeArray[index].size.width)/2)
                        averageX += minWidth + (titleSizeArray[index].size.width)
                    }
                    let tempMinSpace = CGFloat(dataSource.numberOfControllers(self) - 1) * dataSource.pageTabScrollviewMinSpace(self)
                    totalWidth = totalWidth + tempMinSpace + dataSource.pageTabScrollview(self).left
                    
                    var centerPoints:[CGFloat] = [CGFloat]()
                    if totalWidth > topTabScrollViewWidth {
                        centerPoints = equalIntervals
                    }else{
                        centerPoints = averageIntervals
                        totalWidth = topTabScrollViewWidth
                    }
                    _centerPoints = centerPoints
                    
                    
                    let screenBounds:CGRect = UIScreen.main.bounds
                    
                    for index in 0 ..< dataSource.numberOfControllers(self) - 1{
                        
                        let k:CGFloat = (_centerPoints![index + 1] - _centerPoints![index]) / screenBounds.width
                        let b:CGFloat = _centerPoints![index] - k * CGFloat(index) * screenBounds.width
                        _width_b_array.append(b)
                        _width_k_array.append(k)
                    }
                    
                    for index in 0 ..< dataSource.numberOfControllers(self) - 1{
                        let k:CGFloat = (titleSizeArray[index + 1].size.width - titleSizeArray[index].size.width) / screenBounds.width
                        let b:CGFloat = titleSizeArray[index].size.width - k * CGFloat(index) * screenBounds.width
                        _point_k_array.append(k)
                        _point_b_array.append(b)
                    }
                    pageTabScrollview?.contentSize = CGSize(width: totalWidth, height: 0)
                    
                    //加载内容
                    for index in 0 ..< dataSource.numberOfControllers(self){
                        let titleButton = dataSource.pageTabScrollview(self, buttonAtIndex: index)
                        titleButton.setTitle(dataSource.pageView(self, titleAtIndex: index), for: UIControlState.normal)
                        titleButton.titleLabel?.font = dataSource.pageView(self, titleFontAtIndex: index)
                        titleButton.tag = index
                        let x:CGFloat = _centerPoints![index]
                        let width:CGFloat = titleSizeArray[index].size.width
                        let buttonFrame = CGRect(x: x - width / 2, y: 0, width: width, height: pageTabView.frame.height)
                        titleButton.frame = buttonFrame
                        pageTabScrollview?.addSubview(titleButton)
                        titleButton .addTarget(self, action: #selector(self.touchAction(_:)), for: UIControlEvents.touchUpInside)
                        
                    }
                    self.updateSelectedPage(0)
                    
                    lineBottom = UIView(frame: CGRect(x: 0,
                                                      y: pageTabView.frame.height - lineBottomHeight,
                                                      width: (titleSizeArray[0].size.width),
                                                      height: lineBottomHeight))
                    if let lineBottom = lineBottom {
                        lineBottom.center = CGPoint(x: centerPoints[0], y: lineBottom.center.y)
                        lineBottom.backgroundColor = lineBottomColor
                        pageTabScrollview?.addSubview(lineBottom)
                    }
                }
            }
            return pageTabScrollview
        }
        
    }
    
    
    fileprivate var currentIndex:Int = 0{
        willSet(newCurrentPage){
            _currentIndex = newCurrentPage
        }
        didSet{
            var offset:CGFloat =  0
            if let centerPoints = _centerPoints {
                offset = centerPoints[_currentIndex]
            }
            if let pageTabScrollview = pageTabScrollview{
                if  offset < topTabScrollViewWidth / 2 {
                    pageTabScrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }else if offset + topTabScrollViewWidth / 2 < pageTabScrollview.contentSize.width {
                    if offset - topTabScrollViewWidth / 2 - rightButtonWidth / 2 < 0 {
                        pageTabScrollview.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
                    }else {
                        
                        pageTabScrollview.setContentOffset(CGPoint(x: offset - topTabScrollViewWidth / 2 - rightButtonWidth / 2, y: 0), animated: true)
                    }
                }else{
                    pageTabScrollview.setContentOffset(CGPoint(x: pageTabScrollview.contentSize.width - topTabScrollViewWidth , y: 0), animated: true)
                }
            }
        }
        
    }
    
    
    
    //MARK: 位置计算
    fileprivate func getTitleWidth(_ offset:CGFloat) -> CGFloat{
        let screenBounds:CGRect = UIScreen.main.bounds
        let index:Int = Int(offset / screenBounds.width)
        let k:CGFloat = _width_k_array[index]
        let b:CGFloat = _width_b_array[index]
        let x = offset
        return k * x + b
    }
    
    fileprivate func getTilePoint(_ offset:CGFloat) -> CGFloat{
        let screenBounds:CGRect = UIScreen.main.bounds
        let index:Int = Int(offset / screenBounds.width)
        let k:CGFloat = _point_k_array[index]
        let b:CGFloat = _point_b_array[index]
        let x = offset
        return k * x + b
    }
    
    
    //MARK: 更新点击颜色
    fileprivate func updateSelectedPage(_ index:Int){
        if let pageTabScrollview = pageTabScrollview{
            let listBtns = pageTabScrollview.subviews
            for   itemBtn  in listBtns{
                if itemBtn.tag == index {
                    if let btn = itemBtn as? UIButton {
                        btn.setTitleColor(pageSelectedColor, for: UIControlState.normal)
                    }
                }else{
                    if let btn = itemBtn as? UIButton {
                        btn.setTitleColor(pageUnSelectedColor, for: UIControlState.normal)
                    }
                }
                
            }
            
        }
        
    }
    
    
    // MARK: function
    fileprivate func getStringRectSize(_ text:String, _ size:CGSize,_ index:Int) ->CGRect{
        if let dataSource = dataSource {
            let attribute = [NSFontAttributeName:dataSource.pageView(self, titleFontAtIndex: index)]
            let theBounds = NSString(string: text)
            let rect:CGRect = theBounds.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
            return rect
        }
        return CGRect.zero
    }
    
    //YHPageTabScrollview Cell Click
    @objc fileprivate func touchAction(_ sender:UIButton){
        
        isTabClick = true
        
        self.showPageAtIndex(sender.tag, animated: true)
        self.updateSelectedPage(sender.tag)

        UIView.animate(withDuration: 0.2, animations:{
            if let lineBottom = self.lineBottom {
                lineBottom.center = CGPoint(x: (self._centerPoints?[sender.tag])!, y: lineBottom.center.y)
                lineBottom.bounds = CGRect(x: 0, y: 0, width: self.titleSizeArray[sender.tag].width, height:self.lineBottomHeight)
            }
        }, completion: {Void in
        })
        
        
        //pageScrollview?.setContentOffset(CGPoint(x: screenBounds.width * CGFloat(sender.tag), y: 0), animated: true)
    }
    
    //MARK: - NSCacheDelegate
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if (obj as AnyObject).isKind(of: UIViewController.self) {
            let vc = obj as! UIViewController
            //            print("-1- to remove from cache \((vc as! TestChildViewController).pageIndex)")
            if self.childViewControllers.contains(vc) {
                //                print("============================tracking \(scrollView.tracking)  dragging \(scrollView.dragging) decelerating \(scrollView.decelerating)")
                
                let AddCacheToCleanIfNeed = { (midIndex:Int) -> Void in
                    //Modify memCache through showPageAtIndex.
                    var leftIndex = midIndex - 1;
                    var rightIndex = midIndex + 1;
                    if leftIndex < 0 {
                        leftIndex = midIndex
                    }
                    if rightIndex > self.pageCount - 1 {
                        rightIndex = midIndex
                    }
                    if let dataSource = self.dataSource{
                        let leftNeighbour = dataSource.pageView(self, controllerAtIndex: leftIndex)
                        let midPage = dataSource.pageView(self, controllerAtIndex: midIndex)
                        let rightNeighbour = dataSource.pageView(self, controllerAtIndex: rightIndex)
                        
                        if leftNeighbour == vc || rightNeighbour == vc || midPage == vc
                        {
                            self.childsToClean.insert(vc)
                        }
                    }
                    
                }
                
                // When scrollView's dragging, tracking and decelerating are all false.At least it means the cache eviction is not triggered by continuous interaction page changing.
                guard let pageScrollview = pageScrollview else { return }
                
                if pageScrollview.isDragging == false &&
                    pageScrollview.isTracking == false &&
                    pageScrollview.isDecelerating == false
                {
                    let lastPage = self.controllerAtIndex(_lastSelectedIndex)
                    let currentPage = self.controllerAtIndex(_currentIndex)
                    if lastPage == vc || currentPage == vc {
                        self.childsToClean.insert(vc)
                    }
                    //                    print("self.currentPageIndex  \(self.currentPageIndex)")
                } else if pageScrollview.isDragging == true
                {
                    AddCacheToCleanIfNeed(self.guessToIndex)
                    //                    print("self.guessToIndex  \(self.guessToIndex)")
                }
                
                if self.childsToClean.count > 0 {
                    return
                }
                
                //                print("-2- remove index : \((vc as! TestChildViewController).pageIndex)")
                vc.willMove(toParentViewController: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParentViewController()
                //                print("-3- remain ==============================>")
                //                for vcc in self.childViewControllers {
                //                    print("remain \((vcc as! TestChildViewController).pageIndex)")
                //                }
                //                print("-3- remain ==============================>")
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let pageScrollview = pageScrollview else {
            return
        }
        
        if !isTabClick {
            let screenBounds:CGRect = UIScreen.main.bounds
            if let dataSource = dataSource {
                let count = dataSource.numberOfControllers(self)
                if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x >= screenBounds.width * CGFloat(count - 1){
                    return
                }
            }
            if let lineBottom = lineBottom {
                lineBottom.center = CGPoint(x: self.getTitleWidth(scrollView.contentOffset.x), y: lineBottom.center.y)
                lineBottom.bounds = CGRect(x: 0, y: 0, width: self.getTilePoint(scrollView.contentOffset.x), height: lineBottomHeight)
            }
            let page:Int = Int((scrollView.contentOffset.x + screenBounds.width / 2) / screenBounds.width)
            self.updateSelectedPage(page)
        
        }else{
            isTabClick = false
        }
        
        
        
        if scrollView.isTracking == true &&
            scrollView.isDecelerating == true
        {
            print("     guessToIndex  \(guessToIndex)   self.currentPageIndex  \(self._currentIndex)")
        }
        
        if pageScrollview.isDragging == true {
            let offset = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let lastGuessIndex = self.guessToIndex < 0 ? self._currentIndex : self.guessToIndex
            if self.originOffset < Double(offset) {
                self.guessToIndex = Int(ceil((offset)/width))
            } else if (self.originOffset > Double(offset)) {
                self.guessToIndex = Int(floor((offset)/width))
            } else {}
            let maxCount = self.pageCount
            
            
            // 1.Decelerating is false when first drag during discontinuous interaction.
            // 2.Decelerating is true when drag during continuous interaction.
            if (guessToIndex != self._currentIndex &&
                pageScrollview.isDecelerating == false) ||
                pageScrollview.isDecelerating == true
            {
                if lastGuessIndex != self.guessToIndex &&
                    self.guessToIndex >= 0 &&
                    self.guessToIndex < maxCount
                {
                    if let delegate = delegate {
                        delegate.pageScrollviewWillShow(self.guessToIndex, toIndex: self._currentIndex, animated: true)
                        delegate.pageScrollview(self, willTransitonFrom: self.controllerAtIndex(self.guessToIndex),
                                                toViewController: self.controllerAtIndex(self._currentIndex))
                        
                        
                    }
                    
                    self.addVisibleViewContorllerWith(self.guessToIndex)
                    self.controllerAtIndex(self.guessToIndex).beginAppearanceTransition(true, animated: true)
                    //                print("scrollViewDidScroll beginAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
                    /**
                     *  Solve problem: When scroll with interaction, scroll page from one direction to the other for more than one time, the beginAppearanceTransition() method will invoke more than once but only one time endAppearanceTransition() invoked, so that the life cycle methods not correct.
                     *  When lastGuessIndex = self.currentPageIndex is the first time which need to invoke beginAppearanceTransition().
                     */
                    if lastGuessIndex == self._currentIndex {
                        self.controllerAtIndex(self._currentIndex).beginAppearanceTransition(false, animated: true)
                        //                    print("scrollViewDidScroll beginAppearanceTransition  self.currentPageIndex \(self.currentPageIndex)")
                    }
                    
                    if lastGuessIndex != self._currentIndex &&
                        lastGuessIndex >= 0 &&
                        lastGuessIndex < maxCount{
                        self.controllerAtIndex(lastGuessIndex).beginAppearanceTransition(false, animated: true)
                        //                    print("scrollViewDidScroll beginAppearanceTransition  lastGuessIndex \(lastGuessIndex)")
                        self.controllerAtIndex(lastGuessIndex).endAppearanceTransition()
                        //                    print("scrollViewDidScroll endAppearanceTransition  lastGuessIndex \(lastGuessIndex)")
                    }
                }
            }
            
        }
        
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        self.isDecelerating = true
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenBounds:CGRect = UIScreen.main.bounds
        currentIndex = Int((scrollView.contentOffset.x + screenBounds.width / 2 ) / screenBounds.width)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating == false {
            self.originOffset = Double(scrollView.contentOffset.x)
            self.guessToIndex = self._currentIndex
        }
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.isDecelerating == true {
            // Update originOffset for calculating new guessIndex to add controller.
            let offset = scrollView.contentOffset.x
            let width = scrollView.frame.width
            if velocity.x > 0 { // to right page
                self.originOffset = Double(floor(offset/width)) * Double(width)
            } else if velocity.x < 0 {// to left page
                self.originOffset = Double(ceil(offset/width)) * Double(width)
            }
        }
        
        //print("will end tragging  tracking \(scrollView.isTracking)  dragging \(scrollView.isDragging) decelerating \(scrollView.isDecelerating)")
        
        // 如果松手时位置，刚好不需要decelerating。则主动调用刷新page。
        let offset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.size.width
        if (Int(offset * 100) % Int(scrollViewWidth * 100)) == 0 {
            self.updatePageViewAfterTragging(scrollView: scrollView)
        }
        
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let screenBounds:CGRect = UIScreen.main.bounds
        let page:Int = Int((scrollView.contentOffset.x + screenBounds.width / 2) / screenBounds.width)
        self.currentIndex = page
    }
    
    
    //MARK: - Update page after tragging
    func updatePageViewAfterTragging(scrollView:UIScrollView) {
        let newIndex = self.calcIndexWithOffset(scrollView.contentOffset.x,
                                                width: scrollView.frame.size.width)
        let oldIndex = self._currentIndex
        self.currentIndex = newIndex
        
        if newIndex == oldIndex {//最终确定的位置与开始位置相同时，需要重新显示开始位置的视图，以及消失最近一次猜测的位置的视图。
            if self.guessToIndex >= 0 && self.guessToIndex < self.pageCount {
                self.controllerAtIndex(oldIndex).beginAppearanceTransition(true, animated: true)
                //                print("EndDecelerating same beginAppearanceTransition  oldIndex  \(oldIndex)")
                self.controllerAtIndex(oldIndex).endAppearanceTransition()
                //                print("EndDecelerating same endAppearanceTransition  oldIndex  \(oldIndex)")
                self.controllerAtIndex(self.guessToIndex).beginAppearanceTransition(false, animated: true)
                //                print("EndDecelerating same beginAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
                self.controllerAtIndex(self.guessToIndex).endAppearanceTransition()
                //                print("EndDecelerating same endAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
            }
        } else {
            self.controllerAtIndex(newIndex).endAppearanceTransition()
            //            print("EndDecelerating endAppearanceTransition  newIndex  \(newIndex)")
            self.controllerAtIndex(oldIndex).endAppearanceTransition()
            //            print("EndDecelerating endAppearanceTransition  oldIndex  \(oldIndex)")
        }
        
        //归位，用于计算比较
        self.originOffset = Double(scrollView.contentOffset.x)
        self.guessToIndex = self._currentIndex
        
        if let delegate = delegate{
            delegate.pageScrollviewDidShow(self.guessToIndex, toIndex: self._currentIndex, finished:true)
            delegate.pageScrollview(self, didTransitonFrom: self.controllerAtIndex(self.guessToIndex),
                                    toViewController: self.controllerAtIndex(self._currentIndex))
        }
        
        self.isDecelerating = false
        
        self.cleanCacheToClean()
    }
    
    
    
    
    
}
