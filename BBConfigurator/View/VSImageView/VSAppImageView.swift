//
//  VSImageView.swift
//  BBConfigurator
//
//  Created by Vinod on 24/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class VSAppImageView: NSImageView {

    var currentApp: App! = nil
    
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
    
    func getCGPath(bezierPath: NSBezierPath) -> CGPath {
        
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< bezierPath.elementCount {
            let type = bezierPath.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }
        
        return path
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
            
            let imagePath = files[0] as! String
            
            if currentApp != nil,
                FileManager.default.fileExists(atPath: imagePath),
                let appIcon = NSImage(contentsOf: URL(fileURLWithPath: imagePath)),
                let appIconSize = appIcon.sizeForImageAtURL(url: URL(fileURLWithPath: imagePath)),
                appIconSize == CGSize(width: 1024, height: 1024) {
                
                currentApp.setAppIcon(URL(fileURLWithPath: imagePath))
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
    
    override func mouseUp(with event: NSEvent) {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateController(withIdentifier: "GuidelineListViewController") as! GuidelineListViewController
        viewController.app = currentApp
        
        MainViewManager.shared.setMainContainerViewController(viewController)
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        
        let menu = NSMenu(title: "Context menu")
        
        menu.addItem(withTitle: "Remove", action: #selector(removeDefaultImage), keyEquivalent: "")
        
        return menu
    }
    
    func removeDefaultImage() {
        
        if currentApp.deleteAppIcon() {
        
            self.image = nil
        }
    }
}

