//
//  ViewController.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class GuidelineListViewController: NSViewController {
    
    var rootChapters: [Chapter] = []
    
    @IBOutlet var splitView: NSSplitView!
    
    @IBOutlet var tocOutlineView: GuidelineOutlineView!
    
    //@IBOutlet var codeTextView: NSTextView!
    
    @IBOutlet var middlePaneContainerView: NSView!
    
    @IBOutlet var rightPaneContainerView: NSView!
    
    @IBOutlet var treeController: NSTreeController!
    
    @IBOutlet var loadingLabel: NSTextField!
    
    @IBOutlet var appTitleLabel: NSTextField!
    
    @IBOutlet var webView: VSWebView!
    
    var currentMiddlePaneViewController: NSViewController!
    
    var currentRightPaneViewController: NSViewController!
    
    var quickHelpViewController: NSViewController!
    
    var selectedChapterEditViewController: ChapterEditViewController!
    
    var selectedGuidelineEditViewController: DefaultViewController!
    
    var selectedChapterContentViewController: ChapterContentViewController!
    
    var app:App! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tocOutlineView.register(forDraggedTypes: [NSPasteboardTypeString])
        
        tocOutlineView.setDraggingSourceOperationMask(.every, forLocal: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(guidelineListUpdated), name: NSNotification.Name(rawValue: "GuidelineListUpdate"), object: nil)
 
        quickHelpViewController = self.storyboard?.instantiateController(withIdentifier: "QuickHelpViewController") as! NSViewController
        
        selectedChapterEditViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterEditViewController") as! ChapterEditViewController
        
        selectedGuidelineEditViewController = self.storyboard?.instantiateController(withIdentifier: "DefaultViewController") as! DefaultViewController
        
        selectedChapterContentViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterContentViewController") as! ChapterContentViewController
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        loadingLabel.stringValue = "Downloading: Guideline list"

        GuidelineListDownloader.shared.delegate = self
        GuidelineListDownloader.shared.downloadList(app)
        
        appTitleLabel.stringValue = "App: " + app.name + " (P-" + app.projectId + " /U-" + app.uniqueId + " )"
        
        setContainerView(representedObject:nil)
    }
    
    func guidelineListUpdated() {
        
        tocOutlineView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func removeCurrentPane() {
        
        if currentMiddlePaneViewController != nil {
            
            currentMiddlePaneViewController.view.removeFromSuperview()
            currentMiddlePaneViewController.removeFromParentViewController()
        }
        
        if currentRightPaneViewController != nil {
            
            currentRightPaneViewController.view.removeFromSuperview()
            currentRightPaneViewController.removeFromParentViewController()
        }
    }
    
    func setContainerView(representedObject: Any!) {
        
        removeCurrentPane()
        
        if representedObject is Chapter,
            case let selectedChapter = representedObject as! Chapter {
            
            selectedChapterContentViewController.representedChapter = selectedChapter
            self.addChildViewController(selectedChapterContentViewController)
            selectedChapterContentViewController.view.frame = middlePaneContainerView.frame
            middlePaneContainerView .addSubview(selectedChapterContentViewController.view)
            currentMiddlePaneViewController = selectedChapterContentViewController
            
            selectedChapterEditViewController.currentEditChapter = selectedChapter
            self.addChildViewController(selectedChapterEditViewController)
            selectedChapterEditViewController.view.frame = rightPaneContainerView.frame
            rightPaneContainerView .addSubview(selectedChapterEditViewController.view)
            currentRightPaneViewController = selectedChapterEditViewController
        }
        else if representedObject is Guideline,
            case let selectedGuideline = representedObject as! Guideline {
            
            selectedGuidelineEditViewController.currentEditGuideline = selectedGuideline
            self.addChildViewController(selectedGuidelineEditViewController)
            selectedGuidelineEditViewController.view.frame = middlePaneContainerView.frame
            middlePaneContainerView .addSubview(selectedGuidelineEditViewController.view)
            currentMiddlePaneViewController = selectedGuidelineEditViewController
        }
        else if quickHelpViewController != nil{
            
            self.addChildViewController(quickHelpViewController)
            quickHelpViewController.view.frame = rightPaneContainerView.frame
            rightPaneContainerView .addSubview(quickHelpViewController.view)
            currentRightPaneViewController = quickHelpViewController
            
        }
    }
    
    func downloadGuidelineTocIfNeeded() {
        
        if app.pendingGuidelines.count > 0 {
            
            let firstGuideline =  app.pendingGuidelines.first
            
            GuidelineTOCDownloader.shared.delegate = self
            GuidelineTOCDownloader.shared.downloadTOC(firstGuideline!)
            
            if firstGuideline?.getTocTreeString() == "" {
            
            }
            else  {
                
            }
        }
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        
        let appListViewController = self.storyboard?.instantiateController(withIdentifier: "AppListViewController") as! AppListViewController

        MainViewManager.shared.setMainContainerViewController(appListViewController)
    }
}


extension GuidelineListViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            return 1;
        }
        
        return rootChapters.count;
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        
        if let item = item as? Chapter,
            item.chapters.count > index {
            return item.chapters[index]
        }
        
        return ""
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let item = item as? Chapter else {
            
            return false
        }
        
        return !item.chapters.isEmpty
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        guard let item = item as? Chapter else {
            
            return nil
        }
        
        let v = outlineView.make(withIdentifier: "DataCell", owner: self) as! NSTableCellView
        
        if let tf = v.textField {
            
            tf.stringValue = item.name
            
            tf.textColor = NSColor.yellow
        }
        
        return v
    }
}


extension GuidelineListViewController: NSOutlineViewDelegate {
    
    func isHeader(_ item: Any) -> Bool {
        
        if let item = item as? NSTreeNode {
            
            return !(item.representedObject is Chapter)
        }
        else {

            return !(item is Chapter)
        }
    }
 
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        if isHeader(item) {
            
            return outlineView.make(withIdentifier: "HeaderCell", owner: self)
        }
        else {
            
            return outlineView.make(withIdentifier: "DataCell", owner: self)
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    
        return true;
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        
        var isSet = false
        
        let tableView = notification.object
        
        if tableView is NSTableView,
            case let tableView = tableView as! NSTableView {
            
            let clickedRowInTableView = tableView.selectedRow
            
            let selectedItem = tocOutlineView.item(atRow: clickedRowInTableView)
            
            if let selectedItem = selectedItem as? NSTreeNode {
                
                if let representedObject = selectedItem.representedObject,
                    representedObject is Chapter,
                    case let selectedChapter = representedObject as! Chapter{
                    
                    if selectedChapter.isChapter() {
                        
                        isSet = true
                        
                        setContainerView(representedObject:selectedChapter)
                        /*
                        let htmlPagePath = "http://cpms.bbinfotech.com/CMS/project/project_data/\(selectedChapter.guideline.uniqueId)/html/\(selectedChapter.htmlPage).html"
                        
                        let request = URLRequest(url: URL(string: htmlPagePath)!)
                        
                        webView.load(request)
                         */
                    }
                }
                else if let representedObject = selectedItem.representedObject,
                    representedObject is Guideline,
                    case let selectedGuideline = representedObject as! Guideline{
                    
                    isSet = true
                    
                    setContainerView(representedObject:selectedGuideline)
                }
            }
        }
        
        if isSet == false {
            
            setContainerView(representedObject:nil)
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting?
    {
        
        let pb = NSPasteboardItem()
        
        if let chapter = ((item as? NSTreeNode)?.representedObject) as? Chapter {
            
            pb.setString(chapter.id, forType: NSPasteboardTypeString)
            return pb
        }
        
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        return NSDragOperation.move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        
        let pb = info.draggingPasteboard()
        let chapterID = pb.string(forType: NSPasteboardTypeString)
        
        var sourceNode: NSTreeNode?
        
        if let item = item as? NSTreeNode,
            item.children != nil {
         
            
            for node in item.children! {
                
                if let chapter = node.representedObject as? Chapter,
                    chapter.id == chapterID {
                    sourceNode = node
                }
            }
        }
        
        if sourceNode == nil {
            
            return false
        }
     
        
        
        //let indexArr: [Int] = [0, index]
        //let toIndexPath = NSIndexPath(indexes: indexArr, length: 2) as IndexPath
        //treeController.move(sourceNode!, to: toIndexPath)
        
        return true
    }
}

extension GuidelineListViewController : GuidelineListDownloaderDelegate {
    
    func didReceivedGuidelineList(_ app: App, guidelines: NSArray) {
        
        for guidelineDict in guidelines {
            
            if let guidelineDict = guidelineDict as? NSDictionary {
                
                let guideline = Guideline(guidelineDict, app: app)
                app.pendingGuidelines.append(guideline)
            }
        }
        
        loadingLabel.stringValue = "Downloading: Table of Contents"
        
        downloadGuidelineTocIfNeeded()
    }
}

extension GuidelineListViewController : GuidelineTOCDownloaderDelegate {
    
    func didReceivedGuidelineTOC(_ guideline: Guideline, rootChapters: NSArray) {
        
        guideline.rootChaptersData = rootChapters;
        guideline.format = .OldFormat;
        
        if app.pendingGuidelines.first == guideline {
            
            app.guidelines.append(app.pendingGuidelines.removeFirst())
        }
        
        downloadGuidelineTocIfNeeded()
        
        self.performSelector(onMainThread: #selector(addToTreeController), with:guideline, waitUntilDone: false)
    }
    
    func addToTreeController(_ guideline: Guideline) {
        
        guideline.chapters = TocCreator().getRootChapter(guideline, rootChapters: guideline.rootChaptersData)
        
        guideline.exportTocJson()
        
        let index = guideline.app.guidelines.index(of: guideline)! + 1

        guideline.tocDisplayName = "\(index). " + guideline.tocDisplayName
        
        treeController.addObject(guideline)
        
        if app.pendingGuidelines.count == 0 {
            
            loadingLabel.stringValue = ""
        }
        else {
            
            loadingLabel.stringValue = "Loading: \(app.guidelines.count)/\(app.guidelines.count + app.pendingGuidelines.count)"
        }
        
    }
}


