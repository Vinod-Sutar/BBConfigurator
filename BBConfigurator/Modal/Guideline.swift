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
    var rootChapters: [Chapter] = []
    var rootChaptersData: NSArray = []
    var format: Format = .UnknownFormat
    
    init(_ dictionary: NSDictionary, app: App) {
        
        id  = dictionary["gl_id"] as! String
        uniqueId = dictionary["unique_id"] as! String
        name = dictionary["gl_name"] as! String
        self.app = app
    }
    
    func exportTocJson() {
        
        let tocTreeJsonArray:NSMutableArray = []
        
        for chapter in rootChapters {
            
            tocTreeJsonArray.add(chapter.getJsonObject())
        }
        
        
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let folderPath = "\(documentDirectory)/AppMaker/Toc/\(app.projectId!)/\(uniqueId)/"
        
        let filePath = "\(folderPath)TocTree.json"
        
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        if FileManager.default.fileExists(atPath: folderPath) == false {
            
            do {
                
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: tocTreeJsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)

            let tocTreeJsonString = String(data: jsonData, encoding: String.Encoding.utf8)!

            try tocTreeJsonString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            
            print("Error: \(error.localizedDescription)")
        }
        //print("tocTreeJsonArray: \(tocTreeJsonArray)")
    }
    
    func getTocTreeString() -> String {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let filePath = "\(documentDirectory)/AppMaker/Toc/\(app.projectId!)/\(uniqueId)/TocTree.json"
        
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
    
    func updateConnectedPeers() {
        
        exportTocJson()
        
        print("Updating peers...")
    }
}
