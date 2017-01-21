//
//  CustomSearchAlertView.swift
//  WorkerCafe
//
//  Created by huang on 2017/1/8.
//  Copyright © 2017年 Huang. All rights reserved.
//

import UIKit

class CustomSearchAlertView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var optionDict: Dictionary<String,String>!
    private var optionArr: Array<String>! // 放分數或地區
    private var row: Int! // user 點擊的 row
    private var centerX: CGFloat!
    
    func setup(indexPath: Int) {
        row = indexPath
        
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
        self.backgroundColor = UIColor.clear
        
        // MaskView
        let maskView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        maskView.backgroundColor = .black
        maskView.alpha = 0.6
        self.addSubview(maskView)
        
        // alertView
        let alertTableView = UITableView()
        if indexPath == 0 {
            optionArr = locationArr
            alertTableView.frame.size = CGSize(width: maskView.frame.width * 0.666,
                                               height: maskView.frame.height * 0.674)
        } else {
            optionArr = ["0","1", "2", "3", "4", "5"]
            alertTableView.frame.size = CGSize(width: maskView.frame.width * 0.666,
                                               height: 262.002)
            alertTableView.isScrollEnabled = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMaskViewToRemoveAlert(_:)))
        maskView.addGestureRecognizer(tapGesture)
        
        alertTableView.center = maskView.center
        centerX = alertTableView.frame.width / 2
        alertTableView.backgroundColor = .white
        alertTableView.delegate = self
        alertTableView.dataSource = self
        self.addSubview(alertTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return optionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cellLabel = UILabel()
        cellLabel.frame.size = CGSize(width: 45, height: 30)
        cellLabel.center.x = centerX
        cellLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        cellLabel.textAlignment = .center
        cellLabel.text = optionArr[indexPath.row]
        cell.addSubview(cellLabel)
        return cell
        
    }
    private var selectedRow:Int!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        callSuperVIewRemoveSelf()
    }
    
    
    private func callSuperVIewRemoveSelf() {
        var result = Array<Any>()
        result.append(row)
        result.append(optionArr[selectedRow])
        
        //result.insert(row, at: 0)
        //result.insert(optionArr[selectedRow], at: 1)
        print("resultValue:\(result)")
        
        if selectedRow != nil {
            NotificationCenter.default.post(name: REMOVE_KEY_NAME, object: result)
        } else {
            NotificationCenter.default.post(name: REMOVE_KEY_NAME, object: nil)
        }
    }
    
    // click maskView to removed alert
    @objc private func tapMaskViewToRemoveAlert(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: REMOVE_KEY_NAME, object: nil)
        print("tap maskView")
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
