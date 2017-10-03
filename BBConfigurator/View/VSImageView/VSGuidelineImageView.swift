//
//  VSGuidelineImageView.swift
//  BBConfigurator
//
//  Created by Vinod on 01/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class VSGuidelineImageView: NSImageView {
    
    var currentGuideline: Guideline! = nil
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        wantsLayer = true;
        layer?.cornerRadius = dirtyRect.size.width * 0.16
        layer?.borderColor = NSColor(white: 0.80, alpha:1.0).cgColor;
        layer?.borderWidth = 0.5;
        layer?.shadowColor = NSColor.gray.cgColor
        layer?.shadowRadius = 12
        layer?.shadowOffset = CGSize(width: 12, height: 12)
    }
    
    override func awakeFromNib() {
        
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    func setGuideline(guideline: Guideline) {
        
        currentGuideline = guideline
        self.image = guideline.getGuidelineIcon()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        
        if (pBoard.types?.contains(NSURLPboardType))! {
            
            let files = pBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray
            
            let imagePath = files[0] as! String
            
            if currentGuideline != nil,
                FileManager.default.fileExists(atPath: imagePath),
                let guidelineIcon = NSImage(contentsOf: URL(fileURLWithPath: imagePath)),
                let guidelineIconSize = guidelineIcon.sizeForImageAtURL(url: URL(fileURLWithPath: imagePath)),
                guidelineIconSize == CGSize(width: 1024, height: 1024) {
                
                currentGuideline.setGuidelineIcon(URL(fileURLWithPath: imagePath))
                
                return true
            }
        }
        
        return false
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
}
