//
//  ChapterWebContentViewController.swift
//  BBConfigurator
//
//  Created by Vinod on 02/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa
import WebKit

class ChapterWebContentViewController: NSViewController {

    var representedChapter: Chapter! = nil
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        
        if representedChapter != nil {
        
            let htmlPagePath = "http://cpms.bbinfotech.com/CMS/project/project_data/\(representedChapter.guideline.uniqueId)/html/\(representedChapter.htmlPage).html"
            
            let request = URLRequest(url: URL(string: htmlPagePath)!)
            
            webView.load(request)
        }
    }
    
}
