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
        
        layer?.cornerRadius  = 8
    }
    
    
    func shake() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer?.add(animation, forKey: "shake")
    }
}


