//
//  VSCollectionView.swift
//  SwiftCollectionView
//
//  Created by BBI-M USER1033 on 01/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class VSCollectionView: NSCollectionView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    override func deselectItems(at indexPaths: Set<IndexPath>) {
        super.deselectItems(at: indexPaths)
    }
    
    override func newItem(forRepresentedObject object: Any) -> NSCollectionViewItem {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        let item = storyboard.instantiateController(withIdentifier: "VSCollectionViewItem") as! VSCollectionViewItem
        
        return item
    }
}
