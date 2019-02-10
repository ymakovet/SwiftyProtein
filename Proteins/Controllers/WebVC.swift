//
//  WebVC.swift
//  Proteins
//
//  Created by Ruslan NAUMENKO on 2/10/19.
//  Copyright © 2019 UNIT Factory. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    @IBOutlet weak var goBackBtn: UIBarButtonItem! {
        didSet {
            goBackBtn.isEnabled = false
        }
    }
    @IBOutlet weak var goForwardBtn: UIBarButtonItem! {
        didSet {
            goForwardBtn.isEnabled = false
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            else {
                activityIndicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refresh(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        goBackBtn.isEnabled = false
        goForwardBtn.isEnabled = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.canGoBack {
            goBackBtn.isEnabled = true
        }
        if webView.canGoForward {
            goForwardBtn.isEnabled = true
        }
    }
}
