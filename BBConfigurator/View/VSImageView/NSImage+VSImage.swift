//
//  NSImage+VSImage.swift
//  BBConfigurator
//
//  Created by Vinod on 02/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

extension NSImage {
    
    func sizeForImageAtURL(url: URL) -> CGSize? {
        
        guard let imageReps = NSBitmapImageRep.imageReps(withContentsOf: url) else { return nil }
        
        var width: Int = 0
        var height: Int = 0
        
        for imageRep in imageReps {
            
            if imageRep.pixelsWide > width {
                
                width = imageRep.pixelsWide
            }
            
            if imageRep.pixelsHigh > height {
             
                height = imageRep.pixelsHigh
            }
        }
        
        return CGSize(width: width, height: height)
    }
}
