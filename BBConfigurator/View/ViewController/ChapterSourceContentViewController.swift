//
//  ChapterSourceContentViewController.swift
//  BBConfigurator
//
//  Created by Vinod on 02/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class ChapterSourceContentViewController: NSViewController {

    var representedChapter: Chapter! = nil
    
    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        
        if representedChapter != nil {
            
            let htmlPagePath = "http://cpms.bbinfotech.com/CMS/project/project_data/\(representedChapter.guideline.uniqueId)/html/\(representedChapter.htmlPage).html"
            
            do {
                
                textView.string = try String(contentsOf: URL(string: htmlPagePath)!, encoding: String.Encoding.utf8)
            }
            catch {
                
                print("Error: \(error)")
            }
        }
    }
}
