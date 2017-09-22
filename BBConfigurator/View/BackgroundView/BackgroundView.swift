//
//  BackgroundView.swift
//  BBConfig
//
//  Created by BBI-M USER1033 on 21/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class LoginContentBackgroundView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.white.setFill()
        
        NSRectFill(dirtyRect)
        
        wantsLayer = true
        
        layer?.cornerRadius  = 20
    }    
}
