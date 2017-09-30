//
//  VSImageView.swift
//  BBConfigurator
//
//  Created by Vinod on 24/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class AppImageView: NSImageView {

    var currentApp: App! = nil
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        wantsLayer = true;
        layer?.cornerRadius = 20;
        layer?.borderColor = NSColor(white: 0.80, alpha:1.0).cgColor;
        layer?.borderWidth = 0.5;
        layer?.shadowColor = NSColor.gray.cgColor
        layer?.shadowRadius = 12
        layer?.shadowOffset = CGSize(width: 12, height: 12)
    }
    
    override func awakeFromNib() {
        
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    func setApp(app: App) {
        
        currentApp = app
        self.image = app.getAppIcon()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        
        if (pBoard.types?.contains(NSURLPboardType))! {
            
            let files = pBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray
            
            if files.count <= 0 {
                
                return false
            }
            
            let imagePath = files[0] as! String
            
            if currentApp != nil,
                FileManager.default.fileExists(atPath: imagePath) {
                
                currentApp.setAppIcon(URL(fileURLWithPath: imagePath))
            }
        }
        
        return true
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        let sourceDragMask = sender.draggingSourceOperationMask()

        let pBoard = sender.draggingPasteboard()

        if (pBoard.types?.contains(NSColorPboardType))! {
            
            if (sourceDragMask.rawValue & NSDragOperation.generic.rawValue != 0) {
                
                return NSDragOperation.copy;
            }
        }
        
        if (pBoard.types?.contains(NSFilenamesPboardType))! {
            
            if (sourceDragMask.rawValue & NSDragOperation.generic.rawValue != 0) {
                
                return NSDragOperation.copy;
            }
        }
        
        return NSDragOperation.every
    }
    
    override func mouseUp(with event: NSEvent) {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateController(withIdentifier: "GuidelineListViewController") as! GuidelineListViewController
        viewController.app = currentApp
        
        MainViewManager.shared.setMainContainerViewController(viewController)
    }
}
