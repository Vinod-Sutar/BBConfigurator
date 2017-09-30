//
//  AppListViewController.swift
//  BBConfigurator
//
//  Created by BBI-M USER1033 on 01/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa
import MultipeerConnectivity


class AppListViewController: NSViewController {
    
    var allApps:[App] = []
    
    var appStoreSearchURLs: NSMutableArray = []
    
    var filteredApps:[App] = []
    
    var draggingIndexPaths: Set<IndexPath> = []
    
    var draggingItem: NSCollectionViewItem?
    
    var loadingFlag = true
        
    @IBOutlet var appCollectionView: VSCollectionView!
    
    @IBOutlet var searchTextField: NSTextField!
    
    @IBOutlet var loadingLabel: NSTextField!
    
    @IBOutlet var connectedDevicesLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self;
        appCollectionView.register(forDraggedTypes: [NSPasteboardTypeString])
        appCollectionView.setDraggingSourceOperationMask(.every, forLocal:true)

        let item = NSNib(nibNamed: "VSAppCollectionViewItem", bundle: nil)
        
        appCollectionView.register(item, forItemWithIdentifier: "VSAppCollectionViewItem")
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        AppListDownloader.shared.delegate = self
        AppListDownloader.shared.downloadList(UserManager.shared.getCurrentUser()!)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func searchTextChanged(_ sender: Any) {
        
        reloadAppsList()
    }
    
    func setCollectionViewPlaceHolder(_ placeHolderString: String)  {
        
        OperationQueue.main.addOperation (){
            
            self.loadingLabel.isHidden = placeHolderString == ""
            self.loadingLabel.stringValue = placeHolderString
        }
    }
    
    
    public func reloadAppsList() {
        
        
        
        if searchTextField.stringValue == ""
        {
            filteredApps = allApps;
        }
        else
        {
            filteredApps = allApps.filter { $0.name.localizedCaseInsensitiveContains(searchTextField.stringValue)}
        }
        
        filteredApps = filteredApps.sorted(by: {$0.name < $1.name})
        
        setCollectionViewPlaceHolder("")
        
        self.performSelector(onMainThread: #selector(reloadCollectionView), with: nil, waitUntilDone: false)
    }
    
    func reloadCollectionView() {
        
        appCollectionView.reloadData()
    }
}

extension AppListViewController: NSTextFieldDelegate {
    
    func textField(_ textField: NSTextField, textView: NSTextView, shouldSelectCandidateAt index: Int) -> Bool {
        
        print("Hurray")
        return true
    }
}

extension AppListViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        let count: Int = filteredApps.count
        
        if loadingFlag {
            
            setCollectionViewPlaceHolder("Loading apps...")
        }
        else if allApps.count == 0
        {
            setCollectionViewPlaceHolder("No apps found")
        }
        else if count == 0
        {
            setCollectionViewPlaceHolder("No results for \"\(searchTextField.stringValue)\"")
        }
        else
        {
            setCollectionViewPlaceHolder("")
        }
        
        collectionView.isSelectable = searchTextField.stringValue == ""
        
        return count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "VSAppCollectionViewItem", for: indexPath) as! VSAppCollectionViewItem
        
        item.setApp(app: filteredApps[indexPath.item])
        
        return item
    }
    
}

extension AppListViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {

    }
    
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {

        let appCollectionItem: VSAppCollectionViewItem = item as! VSAppCollectionViewItem
        
        appCollectionItem.setApp(app: filteredApps[indexPath.item])
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        
        draggingIndexPaths = indexPaths
        
        if let indexPath = draggingIndexPaths.first,
            let item = collectionView.item(at: indexPath) {
            draggingItem = item
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        
        draggingIndexPaths = []
        draggingItem = nil
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        
        let app:App = filteredApps[indexPath.item]
        
        let pb = NSPasteboardItem()
        pb.setString(app.projectId as String, forType: NSPasteboardTypeString)
        return pb
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        
        if case let proposedDropIndexPath = proposedDropIndexPath.pointee,
            case let draggingItem = draggingItem,
            case let currentIndexPath = collectionView.indexPath(for: draggingItem!), currentIndexPath != proposedDropIndexPath as IndexPath {
            
            let indexPath = proposedDropIndexPath as IndexPath
                        
            if indexPath.item < collectionView.numberOfItems(inSection: 0) {
            
                collectionView.animator().moveItem(at: currentIndexPath!, to: proposedDropIndexPath as IndexPath)
            }
        }
        
        return .move
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionViewDropOperation) -> Bool {
        
        
        for fromIndexPath in draggingIndexPaths {
            
            if indexPath.item < collectionView.numberOfItems(inSection: 0) {
                
                let removeIndex = fromIndexPath.item
                
                let removedGuideline = filteredApps.remove(at: removeIndex)
                
                filteredApps.insert(removedGuideline, at: indexPath.item)
            }
        }
        
        return true
    }
}

extension AppListViewController : AppListDownloaderDelegate {
    
    func didReceivedAppList(_ apps: [App]) {
        
        loadingFlag = false
        
        filteredApps = apps
        
        allApps = apps
        
        reloadAppsList()
        
    }
}
