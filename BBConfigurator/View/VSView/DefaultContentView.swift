//
//  DefaultContentView.swift
//  BBConfigurator
//
//  Created by Vinod on 02/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class DefaultContentView: NSView {

    var currentGuideline: Guideline! = nil
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        /*
        wantsLayer = true;
        layer?.borderColor = NSColor(white: 0.80, alpha:1.0).cgColor;
        layer?.borderWidth = 0.5;
        layer?.shadowColor = NSColor.gray.cgColor
        layer?.shadowRadius = 12
        layer?.shadowOffset = CGSize(width: 12, height: 12)
         */
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = NSColor.black.cgColor
        yourViewBorder.lineDashPattern = [5, 5]
        yourViewBorder.frame = dirtyRect
        yourViewBorder.fillColor = nil
        
        let bezierPath = NSBezierPath(roundedRect: dirtyRect, xRadius: 0, yRadius: 0)
        yourViewBorder.path = bezierPath.cgPath
        
        layer?.addSublayer(yourViewBorder)
    }
    
    override func awakeFromNib() {
        
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        
        if (pBoard.types?.contains(NSURLPboardType))! {
            
            let files = pBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray
            
            var isAnySet:Bool = false
            
            for imagePath in files {
                
                let imagePath = imagePath as! String
                
                if currentGuideline != nil,
                    FileManager.default.fileExists(atPath: imagePath),
                    let defaultImage = NSImage(contentsOf: URL(fileURLWithPath: imagePath)) {
                    
                    let defaultImageSize = defaultImage.sizeForImageAtURL(url: URL(fileURLWithPath: imagePath))
                    
                    var defaultImageType: DefaultImageType = .Unknown
                    
                    if defaultImageSize == CGSize(width: 640, height: 960) {
                        
                        defaultImageType = .iPhone4
                    }
                    else if defaultImageSize == CGSize(width: 640, height: 1136) {
                        
                        defaultImageType = .iPhone5AndAbove
                    }
                    else if defaultImageSize == CGSize(width: 768, height: 1024) {
                        
                        defaultImageType = .iPadPortrait
                    }
                    else if defaultImageSize == CGSize(width: 1536, height: 2048) {
                        
                        defaultImageType = .iPadPortrait2x
                    }
                    else if defaultImageSize == CGSize(width: 1024, height: 768) {
                        
                        defaultImageType = .iPadLandscape
                    }
                    else if defaultImageSize == CGSize(width: 2048, height: 1536) {
                        
                        defaultImageType = .iPadLandscape2x
                    }
                    
                    if defaultImageSize != .zero,
                        defaultImageType != .Unknown {
                        
                        currentGuideline.setDefaults(URL(fileURLWithPath: imagePath), defaultImageType: defaultImageType)
                        isAnySet = true
                    }
                    else {
                        
                        Swift.print("Cannot accept with size: \(String(describing: defaultImage.size))")
                    }
                }
            }

            NotificationCenter.default.post(name: NSNotification.Name("DefaultContentViewUpdate"), object: nil)

            if isAnySet {

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
    
    func setDefaultImage() {
        
    }
}
