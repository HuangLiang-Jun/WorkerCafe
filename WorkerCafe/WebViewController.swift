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
    var urlStr = String()
    var nameStr = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:URL!
        if (urlStr.contains("\n")) {
            
            let tmpArr = urlStr.components(separatedBy: "\n")
            let correctUrlStr = tmpArr.first!
            url = URL(string: correctUrlStr)
        }else {
            
            url = URL(string: urlStr)
        }

        print("url:\(url)")
        let request = URLRequest(url: url)
        officialWebView.loadRequest(request)
        officialWebView.delegate = self
        self.navigationItem.title = nameStr
    }

    // MARK: WebView Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
  
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activity.stopAnimating()
        maskView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    
    }

}
