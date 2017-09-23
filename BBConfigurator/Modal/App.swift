//
//  App.swift
//  SwiftTOC
//
//  Created by BBI-M USER1033 on 18/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class App: NSObject {
    
    let projectId: String!
    let uniqueId: String!
    let name: String!
    
    var guidelines: [Guideline] = []
    var pendingGuidelines: [Guideline] = []
    
    init(_ projectId: String, uniqueId: String, name: String) {
        
        self.projectId = projectId
        self.uniqueId = uniqueId
        self.name = name
    }
    
    func image() -> NSImage? {
        
        if FileManager.default.fileExists(atPath: imagePath()) {
            
             return NSImage(contentsOfFile: imagePath())
        }
        
        return nil
    }
    
    func imagePath() -> String {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return "\(documentDirectory)/Images/\(projectId).png"
    }
}
