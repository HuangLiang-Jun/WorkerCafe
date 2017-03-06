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
    private let fullScreenBounds = UIScreen.main.bounds // user 螢幕尺寸
    private let menuSwichPageScale: Float = 0.25 // 動畫速度
    private var callOutFrame: CGRect! // menu callout frame
    private var callBackFrame: CGRect! // menu callback frame
    
    private func setup() {
        
        callOutFrame = CGRect(x: 0,
                              y: 64, // navigationBar height:64 (for any size)
                              width: fullScreenBounds.width * menuScreenScale,
                              height: fullScreenBounds.height - 64)
        
        callBackFrame = CGRect(x: -(fullScreenBounds.width * menuScreenScale),
                               y: 64,
                               width: fullScreenBounds.width * menuScreenScale,
                               height: fullScreenBounds.height - 64)
        
        
        self.backgroundColor = UIColor(red:1.00, green:0.86, blue:0.73, alpha:1.0)
        self.frame = callBackFrame
        
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: fullScreenBounds.height * 0.00749,
                                               width: self.frame.width,
                                               height: self.frame.height * 0.08))
        
        titleLabel.text = "搜尋咖啡店"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        titleLabel.textAlignment = NSTextAlignment.center
        //titleLabel.backgroundColor = .clear //
        self.addSubview(titleLabel)
        addMenu(titleFrame: titleLabel.frame)
        print("slideViewSetup")
        
    }
    var menuTableView:UITableView!
    
    private func addMenu(titleFrame: CGRect) {
        let nib = UINib(nibName: "SearchMenuCell", bundle: nil)
        let locationNib = UINib(nibName: "LocationCell", bundle: nil)
        print("-----")
        print(self.frame.height)
        menuTableView = UITableView(frame: CGRect(x: 0,
                                                  y: titleFrame.size.height + 5,
                                                  width: self.frame.width,
                                                  height: self.frame.height * 0.52473))
        menuTableView.separatorStyle = .none
        menuTableView.register(nib, forCellReuseIdentifier: "Cell")
        menuTableView.register(locationNib, forCellReuseIdentifier: "LocationCell")
        menuTableView.rowHeight = menuTableView.frame.height * 0.2
        menuTableView.allowsSelection = true
        menuTableView.isScrollEnabled = false
        menuTableView.backgroundColor = .clear
        self.addSubview(menuTableView)
        addSearchBtn(menuFrame: menuTableView.frame)
    }
    
    var searchBtn: UIButton!
    var defaultBtn: UIButton!
    //var aboutMeBtn: UIButton!
    
    private func addSearchBtn(menuFrame: CGRect) { //開始搜尋按鈕
        let btnColor = UIColor(red:1.00, green:0.35, blue:0.04, alpha:1.0)
        defaultBtn = UIButton(frame: CGRect(x: self.frame.width / 3 ,
                                            y: menuFrame.size.height + 100,
                                            width: self.frame.width * 0.4,
                                            height: 30))

        defaultBtn.setTitle("恢復預設", for: .normal)
        defaultBtn.backgroundColor = btnColor
        defaultBtn.layer.cornerRadius = 6.0

        searchBtn = UIButton(frame: CGRect(x: self.frame.width / 3,
                                           y: defaultBtn.frame.origin.y + 40,
                                           width: self.frame.width * 0.4,
                                           height: 30))
        
        searchBtn.setTitle("搜尋", for: .normal)
        searchBtn.backgroundColor = btnColor
        searchBtn.layer.cornerRadius = 6.0

        
        self.addSubview(defaultBtn)
        self.addSubview(searchBtn)
        
        
    }
    
    
    func callMenu() { // 搜尋menu 顯示 or 隱藏
        UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
            if self.frame.origin.x == 0 {
                self.frame = self.callBackFrame
            } else {
                self.frame = self.callOutFrame
            }
        }
    }
    
    
}
