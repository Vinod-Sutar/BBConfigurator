//
//  VSDefaultImageView.swift
//  BBConfigurator
//
//  Created by Vinod on 01/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

enum DefaultImageType: Int {
    
    case Unknown = 0
    case iPhone4 = 1
    case iPhone5AndAbove = 2
    case iPadPortrait = 3
    case iPadPortrait2x = 4
    case iPadLandscape = 5
    case iPadLandscape2x = 6
}

class VSDefaultImageView: NSImageView {
    
    var currentGuideline: Guideline! = nil
    
    var defaultImageType: DefaultImageType = .Unknown
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        wantsLayer = true;
        layer?.borderColor = NSColor(white: 0.80, alpha:1.0).cgColor;
        layer?.borderWidth = 0.5;
        layer?.shadowColor = NSColor.gray.cgColor
        layer?.shadowRadius = 12
        layer?.shadowOffset = CGSize(width: 12, height: 12)
    }
    
    override func awakeFromNib() {
        
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        
        if (pBoard.types?.contains(NSURLPboardType))! {
            
            let files = pBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray
            
            let imagePath = files[0] as! String
            
            if currentGuideline != nil,
                FileManager.default.fileExists(atPath: imagePath),
                let defaultImage = NSImage(contentsOf: URL(fileURLWithPath: imagePath)) {
                
                var imageSize = CGSize.zero
                
                if defaultImageType == .iPhone4 {
                    
                    imageSize = CGSize(width: 640, height: 960)
                }
                else if defaultImageType == .iPhone5AndAbove {
                    
                    imageSize = CGSize(width: 640, height: 1136)
                }
                else if defaultImageType == .iPadPortrait {
                    
                    imageSize = CGSize(width: 768, height: 1024)
                }
                else if defaultImageType == .iPadPortrait2x {
                    
                    imageSize = CGSize(width: 1536, height: 2048)
                }
                else if defaultImageType == .iPadLandscape {
                    
                    imageSize = CGSize(width: 1024, height: 768)
                }
                else if defaultImageType == .iPadLandscape2x {
                    
                    imageSize = CGSize(width: 2048, height: 1536)
                }
                
                
                let defaultImageSize = defaultImage.sizeForImageAtURL(url: URL(fileURLWithPath: imagePath))
                
                if defaultImageSize == imageSize {
                
                    currentGuideline.setDefaults(URL(fileURLWithPath: imagePath), defaultImageType: defaultImageType)
                    
                    return true
                }
                else {
                    
                    Swift.print("Cannot accept with size: \(String(describing: defaultImage.size))")
                }
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
    
    override func menu(for event: NSEvent) -> NSMenu? {
        
        let menu = NSMenu(title: "Context menu")
        
        menu.addItem(withTitle: "Remove", action: #selector(removeDefaultImage), keyEquivalent: "")
        
        return menu
    }
    
    func removeDefaultImage() {
        
        self.image = nil
    }
    
    func setDefaultImage() {
        
        self.image = currentGuideline.getDefaults(defaultImageType: defaultImageType)
    }
    
}
