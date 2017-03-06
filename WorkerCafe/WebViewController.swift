//
//  WebViewController.swift
//  WorkerCafe
//
//  Created by huang on 2017/1/25.
//  Copyright © 2017年 Huang. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var officialWebView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loadingImg: UIImageView!
    @IBOutlet weak var maskView: UIView!
    var urlStr:String?
    var nameStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:URL!
        if let newUrlStr = urlStr {
            if (newUrlStr.contains("\n")) {
                
                let tmpArr = newUrlStr.components(separatedBy: "\n")
                let correctUrlStr = tmpArr.first!
                url = URL(string: correctUrlStr)
            }else {
                
                url = URL(string: newUrlStr)
            }
            
            print("url:\(url)")
            guard let newUrl = url else {
                print("url解析失敗")
                return
            }
            print("newUrl(\(newUrl))")
            let request = URLRequest(url: newUrl)
            officialWebView.loadRequest(request)
            officialWebView.delegate = self
            self.navigationItem.title = nameStr
        }
    }
    
    // MARK: WebView Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activity.stopAnimating()
        maskView.isHidden = true
    }
    
}
