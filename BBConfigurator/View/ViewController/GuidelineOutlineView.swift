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
                    case let selectedChapter = representedObject as! Chapter{
                    
                    if selectedChapter.isChapter() {
                        
                        let menu = NSMenu(title: "Context menu")
                        
                        menu.insertItem(withTitle: "Delete", action: #selector(deleteChapter), keyEquivalent: "", at: 0)
                        
                        menu.insertItem(NSMenuItem.separator(), at: 0)
                        
                        menu.insertItem(withTitle: "Edit", action: #selector(editChapter), keyEquivalent: "", at: 0)
                        
                        return menu;
                    }
                }
            }
        }
        
        return nil
    }
    
    func editChapter() {
        
        self.print("Edit clicked")
    }
    
    func deleteChapter() {
        
        self.print("Delete clicked")
    }
}
