//
//  VSWebView.swift
//  BBConfigurator
//
//  Created by Vinod on 24/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa
import WebKit

class VSWebView: WKWebView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        uiDelegate = self
        
        navigationDelegate = self
    }
}

extension VSWebView : WKUIDelegate {
    
}

extension VSWebView : WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            
            //if navigationAction.navigationType == WKNavigationType.linkActivated && !(navigationAction.request.url?.host?.lowercased().hasPrefix("www.example.com"))! {
            
            decisionHandler(.allow)
        }
        else
        {
            //decisionHandler(.cancel)
            
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
}


