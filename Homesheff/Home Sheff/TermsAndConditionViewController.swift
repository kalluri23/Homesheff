//
//  TermsAndConditionViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/21/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

extension WKWebView {
    func load(_ urlString: String)  {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

class TermsAndConditionViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    var isTermsAndCondition = true
    
    var urlString : String? {
            if isTermsAndCondition {
                return "https://homesheff.com/#/terms-of-service"
            } else {
                return "https://homesheff.com/#/privacy-policy"
        }
    }
    
    
    @IBAction func dismissViewControllere(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
        
        loadRequest()
    }
    
    func loadRequest()  {
        if let url = URL(string: urlString ?? "") {
            loadingIndicator.startAnimating()
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension TermsAndConditionViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       if !webView.isLoading {
            loadingIndicator.stopAnimating()
        }
    }
}
