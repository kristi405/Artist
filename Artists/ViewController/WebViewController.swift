//
//  WebViewController.swift
//  Artists
//
//  Created by kris on 23/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    var eventURL = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 2, width: 414, height: 15))
        progressView.backgroundColor = .white
        webView.addSubview(progressView)
        self.progressView = progressView
        
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        webView.navigationDelegate = self
        fetchWebView()
    }
    
    func fetchWebView() {
        
        guard let url = URL(string: eventURL) else {return}
        let request = URLRequest(url: url)
        
        webView.load(request)

    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    private func showProgressView() {
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
               self.progressView.alpha = 1
           }, completion: nil)
       }

       private func hideProgressView() {
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
               self.progressView.alpha = 0
           }, completion: nil)
       }
}


// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       showProgressView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
