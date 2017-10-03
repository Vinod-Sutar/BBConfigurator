//
//  Guideline.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

enum Format: Int {
    
    case UnknownFormat = 1
    case OldFormat = 2
    case NewFormat = 3
}

class Guideline: NSObject {
    
    var id: String = ""
    var uniqueId: String = ""
    var name: String = ""
    var app: App!
    var chapters: [Chapter] = []
    var tocDisplayName = ""
    var rootChaptersData: NSArray = []
    var format: Format = .UnknownFormat
    
    override init() {
        
    }
    
    init(_ dictionary: NSDictionary, app: App) {
        
        id  = dictionary["gl_id"] as! String
        uniqueId = dictionary["unique_id"] as! String
        name = dictionary["gl_name"] as! String
        tocDisplayName = dictionary["gl_name"] as! String
        self.app = app
        
    }
    
    func isChapter() -> Bool {
        return false
    }
    
    func exportTocJson() {
        
        let tocTreeJsonArray:NSMutableArray = []
        
        for chapter in chapters {
            
            tocTreeJsonArray.add(chapter.getJsonObject())
        }
        
        let guidelineFilePath = getGuidelineFilePath()
        
        if guidelineFilePath != nil {
            
            let fileURL = URL(fileURLWithPath: guidelineFilePath!)
            
            do {
                
                let guidelineJson = [
                    
                    "meta-info" : [
                        "version" : "1.0",
                        "updatedBy" : "Vinod Sutar",
                        "updatedOn" : "20170928 1715 +0530"
                    ],
                    "guideline-info" : [
                        
                        "id" : id,
                        "uniqueId" : uniqueId,
                        "name" : name,
                        "appId" : app.projectId,
                    ],
                    "design" : [
                        
                    ],
                    "chapters" : tocTreeJsonArray
                    ] as [String : Any]
                
                let jsonData = try JSONSerialization.data(withJSONObject: guidelineJson, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let tocTreeJsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                
                try tocTreeJsonString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getTocTreeString() -> String {
        
        let userDocumentPath = UserManager.shared.getCurrentUser().documentPath()
        
        let filePath = "\(userDocumentPath)Toc/\(app.projectId!)/\(uniqueId)/TocTree.json"
        
        if FileManager.default.fileExists(atPath: filePath) {
            
            let fileURL = URL(fileURLWithPath: filePath)

            
            do {
                
                return try String(contentsOf: fileURL)
            }
            catch {
                
                print("Error -> \(error)")
            }
        }
        
        return ""
    }
    
    func getGuidelineFilePath() -> String! {
        
        if let user = UserManager.shared.getCurrentUser() {
            
            let guidelineFolderPath = "\(user.documentPath())\(app.projectId!)/\(uniqueId)/"
            
            if FileManager.default.fileExists(atPath: guidelineFolderPath) == false {
                
                do {
                    
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: guidelineFolderPath), withIntermediateDirectories: true, attributes: nil)
                    
                }
                catch {
                    
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            return guidelineFolderPath + "guidelineInfo.json"
        }
        
        return nil
    }
    
    func updateConnectedPeers() {
        
        exportTocJson()
        
        print("Updating peers...")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func getGuidelineIcon() -> NSImage! {
        
        if let imagePath = getGuidelineIconPath(),
            let image = NSImage(contentsOfFile: imagePath) {
            
            return image
        }
        
        return nil
    }
    
    func setGuidelineIcon(_ atPath: URL) {
        
        do {
            
            let toPath = URL(fileURLWithPath: getGuidelineIconPath())
            
            if FileManager.default.fileExists(atPath: getGuidelineIconPath()) {
                
                try FileManager.default.removeItem(at: toPath)
            }
            
            try FileManager.default.copyItem(at: atPath, to: toPath)
            
            reloadGuidelineIconToPeers()
        }
        catch {
            
            print(error)
        }
    }
    
    func getGuidelineIconPath() -> String! {
        
        var filePath: String! = nil
        
        if let user = UserManager.shared.getCurrentUser() {
            
            let folderPath = user.documentPath() + app.projectId + "/" + uniqueId + "/Images/"
            
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
    
    func reloadGuidelineIconToPeers() {
        
        if FileManager.default.fileExists(atPath: getGuidelineIconPath()) {
            
            MPCManager.shared.sendResourcesToPeers(getGuidelineIconPath(), withName: "image--" + "guidelineIcon_" + id + ".png")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func getDefaults(defaultImageType imageType: DefaultImageType) -> NSImage! {
        
        if let imagePath = getGuidelineDefaultsPath(defaultImageType: imageType),
            let image = NSImage(contentsOfFile: imagePath) {
            
            return image
        }
        
        return nil
    }
    
    func setDefaults(_ atPath: URL, defaultImageType imageType: DefaultImageType) {
        
        do {
            
            let toPath = URL(fileURLWithPath: getGuidelineDefaultsPath(defaultImageType:imageType))
            
            if FileManager.default.fileExists(atPath: getGuidelineDefaultsPath(defaultImageType:imageType)) {
                
                try FileManager.default.removeItem(at: toPath)
            }
            
            try FileManager.default.copyItem(at: atPath, to: toPath)
            
            reloadGuidelineIconToPeers()
        }
        catch {
            
            print(error)
        }
    }
    
    func getGuidelineDefaultsPath(defaultImageType imageType: DefaultImageType) -> String! {
        
        var filePath: String! = nil
        
        if let user = UserManager.shared.getCurrentUser() {
            
            let folderPath = user.documentPath() + app.projectId + "/" + uniqueId + "/Images/Defaults/"
            
            filePath = folderPath + "Icon.png"
            
            if imageType == .iPhone4 {
            
                filePath = folderPath + "Default@2x.png"
            }
            else if imageType == .iPhone5AndAbove {
                
                filePath = folderPath + "Default-568h@2x.png"
            }
            else if imageType == .iPadPortrait {
                
                filePath = folderPath + "Default-Portrait~ipad.png"
            }
            else if imageType == .iPadPortrait2x {
                
                filePath = folderPath + "Default-Portrait@2x~ipad.png"
            }
            else if imageType == .iPadLandscape {
                
                filePath = folderPath + "Default-Landscape~ipad.png"
            }
            else if imageType == .iPadLandscape2x {
                
                filePath = folderPath + "Default-Landscape@2x~ipad.png"
            }
            else {
                
                filePath = folderPath + "Defaults.png"
            }
            
            
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
    
    func reloadGuidelineDefaultsToPeers(defaultImageType imageType: DefaultImageType) {
        
        if FileManager.default.fileExists(atPath: getGuidelineDefaultsPath(defaultImageType: imageType)) {
            
            MPCManager.shared.sendResourcesToPeers(getGuidelineDefaultsPath(defaultImageType: imageType), withName: "image--" + "guidelineDefault_" + id + ".png")
        }
    }
}
