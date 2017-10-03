//
//  GuidelineOutlineView.swift
//  SwiftTOC
//
//  Created by BBI-M USER1033 on 13/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class GuidelineOutlineView: NSOutlineView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
   
        
        let point = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)
        
        
        if row > 0 {
            
            if let selectedItem = self.item(atRow: row) as? NSTreeNode {
                
                if let representedObject = selectedItem.representedObject,
                    representedObject is Chapter,
                    case let selectedChapter = representedObject as! Chapter {
                    
                    
                    let menu = NSMenu(title: "Context menu")
                    
                    
                    menu.addItem(withTitle: "Add parent chapter", action: #selector(addParentChapter), keyEquivalent: "")
                    
                    menu.addItem(NSMenuItem.separator())
                    menu.addItem(withTitle: "Add chapter above", action: #selector(addChapterAbove), keyEquivalent: "")
                    menu.addItem(withTitle: "Add chapter below", action: #selector(addChapterBelow), keyEquivalent: "")
                    
                    menu.addItem(NSMenuItem.separator())
                    
                    let chapterName = "Delete \"" + selectedChapter.name + "\""
                    
                    menu.addItem(withTitle: chapterName, action: #selector(deleteChapter), keyEquivalent: "")
                    
                    return menu;
                }
            }
        }
        
        return nil
    }
    
    func addParentChapter() {
        
        Swift.print("Add Parent Chapter")
    }
    
    func addChapterAbove() {
        
        Swift.print("Add Chapter Above")
    }
    
    func addChapterBelow() {
        
        Swift.print("Add Chapter Below")
    }
    
    func deleteChapter() {
        
        Swift.print("Delete clicked")
    }
}
