//
//  SlideMenu.swift
//  WorkerCafe
//
//  Created by huang on 2016/12/28.
//  Copyright © 2016年 Huang. All rights reserved.
//

import UIKit


class SlideMenu: UIView {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    // Xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //self.setup()
    }
    
    private let menuScreenScale: CGFloat = 0.8 // menu大小
    private let menuPointYScale: CGFloat = 0.08533 // menu Y軸位置
    private let menuScreenHeightScale: CGFloat = 0.9146 // menu 高度
    private let fullScreenBounds = UIScreen.main.bounds // user 螢幕尺寸
    private var callOutFrame: CGRect! // menu callout frame
    private var callBackFrame: CGRect! // menu callback frame
    
    private func setup() {
        
        callOutFrame = CGRect(x: 0,
                              y: fullScreenBounds.height * menuPointYScale,
                              width: fullScreenBounds.width * menuScreenScale,
                              height: fullScreenBounds.height * menuScreenHeightScale)
        
        callBackFrame = CGRect(x: -(fullScreenBounds.width * menuScreenScale),
                               y: fullScreenBounds.height * menuPointYScale,
                               width: fullScreenBounds.width * menuScreenScale,
                               height: fullScreenBounds.height * menuScreenHeightScale)
        
        
        self.backgroundColor = .blue
        self.frame = callBackFrame
        
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.frame.width,
                                               height: self.frame.height * 0.1))
        titleLabel.text = "我要找的咖啡店"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(25))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.backgroundColor = .white
        self.addSubview(titleLabel)
        addMenu(titleFrame: titleLabel.frame)
        print("slideViewSetup")
        
    }
    var menuTableView:UITableView!
    
    private func addMenu(titleFrame: CGRect) {
        let nib = UINib(nibName: "SearchMenuCell", bundle: nil)
        let locationNib = UINib(nibName: "LocationCell", bundle: nil)
        
        menuTableView = UITableView(frame: CGRect(x: 0,
                                                  y: titleFrame.size.height + 5,
                                                  width: self.frame.width,
                                                  height: 350))
        
        menuTableView.register(nib, forCellReuseIdentifier: "Cell")
        menuTableView.register(locationNib, forCellReuseIdentifier: "LocationCell")
        menuTableView.rowHeight = 70
        menuTableView.allowsSelection = true
        menuTableView.isScrollEnabled = false
        menuTableView.backgroundColor = .red
        self.addSubview(menuTableView)
        addSearchBtn(menuFrame: menuTableView.frame)
    }
    
    var searchBtn: UIButton!
    private func addSearchBtn(menuFrame: CGRect) { //開始搜尋按鈕
        
        searchBtn = UIButton(frame: CGRect(x: self.frame.width / 3 ,
                                           y: menuFrame.size.height + 100,
                                           width: 120,
                                           height: 30))
        
        searchBtn.setTitle("搜尋", for: .normal)
        searchBtn.backgroundColor = .orange
        self.addSubview(searchBtn)
        
    }
    
    private let menuSwichPageScale: Float = 0.25 // 動畫速度
    func callMenu() { // 搜尋menu 顯示 or 隱藏
        UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
            if self.frame.origin.x == 0 {
                self.frame = self.callBackFrame
            } else {
                self.frame = self.callOutFrame
            }
        }
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
