//
//  ChapterContentViewController.swift
//  BBConfigurator
//
//  Created by Vinod on 02/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class ChapterContentViewController: NSViewController {

    var representedChapter: Chapter! = nil
    
    @IBOutlet var containerView: NSView!
    
    @IBOutlet var segmentedController: NSSegmentedControl!
    
    var currentContainerViewController: NSViewController!
    
    var chapterWebContentViewController: ChapterWebContentViewController!
    
    var chapterSourceContentViewController: ChapterSourceContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContainerView()
    }
    
    @IBAction func segmentBarClicked(_ sender: Any) {
        
        setContainerView()
    }
    
    func setContainerView() {
        
        if currentContainerViewController != nil {
            
            currentContainerViewController.view.removeFromSuperview()
            currentContainerViewController.removeFromParentViewController()
        }
        
        
        if representedChapter != nil {
            
            if segmentedController.selectedSegment == 0 {
                
                if chapterWebContentViewController == nil {
                    
                    chapterWebContentViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterWebContentViewController") as! ChapterWebContentViewController
                }
                
                chapterWebContentViewController.representedChapter = representedChapter
                self.addChildViewController(chapterWebContentViewController)
                chapterWebContentViewController.view.frame = containerView.frame
                containerView.addSubview(chapterWebContentViewController.view)
                currentContainerViewController = chapterWebContentViewController
            }
            else if segmentedController.selectedSegment == 1 {
                
                if chapterSourceContentViewController == nil {
                    
                    chapterSourceContentViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterSourceContentViewController") as! ChapterSourceContentViewController
                }
                
                chapterSourceContentViewController.representedChapter = representedChapter
                self.addChildViewController(chapterSourceContentViewController)
                chapterSourceContentViewController.view.frame = containerView.frame
                containerView.addSubview(chapterSourceContentViewController.view)
                currentContainerViewController = chapterSourceContentViewController
            }
            
        }

    }
    
    
    
}
