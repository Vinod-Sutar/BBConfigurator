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
    
    
    func getAppIcon() -> NSImage! {
       
        if let imagePath = getAppIconPath(),
            let image = NSImage(contentsOfFile: imagePath) {
            
            return image
        }
        
        return nil
    }
    
    
    func setAppIcon(_ atPath: URL) {
        
        do {
            
            let toPath = URL(fileURLWithPath: getAppIconPath())
            
            if FileManager.default.fileExists(atPath: getAppIconPath()) {
                
                try FileManager.default.removeItem(at: toPath)
            }
            
            try FileManager.default.copyItem(at: atPath, to: toPath)
            
            reloadAppIconToPeers()
        }
        catch {
            
            print(error)
        }
    }
    
        
    func getAppIconPath() -> String! {
        
        var filePath: String! = nil
        
        if let user = UserManager.shared.getCurrentUser() {
            
            let folderPath = user.documentPath() + projectId + "/"
            
            filePath = folderPath + "Icon.png"
            
            if FileManager.default.fileExists(atPath: folderPath) == false {
                
                do {
                    
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    
                    Swift.print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        return filePath
    }
    
    func deleteAppIcon() -> Bool {
        
        do {
            
            let toPath = URL(fileURLWithPath: getAppIconPath())
            
            if FileManager.default.fileExists(atPath: getAppIconPath()) {
                
                try FileManager.default.removeItem(at: toPath)
            }
            
            reloadAppIconToPeers()
            
            return true
        }
        catch {
            
            print(error)
        }
        
        return false
    }
    
    func reloadAppIconToPeers() {
        
        if FileManager.default.fileExists(atPath: getAppIconPath()) {
            
            MPCManager.shared.sendResourcesToPeers(getAppIconPath(), withName: "image--" + "appIcon_" + projectId + ".png")
        }
    }
}
