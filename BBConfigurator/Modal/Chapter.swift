//
//  Chapter.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class Chapter: NSObject {
    
    
    var guideline: Guideline!
    var id: String = ""
    var name: String = ""
    var numTree: String = ""
    var tocName: String = ""
    var mailEnabled: Bool = false
    var PDFEnabled: Bool = false
    var htmlPage: String = ""
    var chapters: [Chapter] = []
    var textColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    
    override init() {
        
    }
    
    init(_ guideline: Guideline, chapterDictionary: NSDictionary) {
        
        self.guideline = guideline
        id = chapterDictionary["id"] as! String
        name = chapterDictionary["name"] as! String
        htmlPage = chapterDictionary["htmlPage"] as! String
        
        if let isMailEnabled = chapterDictionary["mailEnabled"] {
            
            mailEnabled = isMailEnabled as! Bool
        }
        
        if let isPDFEnabled = chapterDictionary["PDFEnabled"] {
            
            PDFEnabled = isPDFEnabled as! Bool
        }
        
    }
    
    init(_ guideline: Guideline, oldChapterDictionary: NSDictionary) {
    
        
        self.guideline = guideline
        id = oldChapterDictionary["id"] as! String
        name = oldChapterDictionary["nametree"] as! String
        numTree = oldChapterDictionary["numtree"] as! String
        htmlPage = oldChapterDictionary["htmlpage"] as! String
        
        if let isMailEnabled = oldChapterDictionary["emailContent"] {
            
            mailEnabled = isMailEnabled as! Bool
        }
        
        if let isPDFEnabled = oldChapterDictionary["haspdf"] {
            
            PDFEnabled = isPDFEnabled as! Bool
        }
    }
    
    func tocDisplayName() -> String {
        
        var emojiString = ""
        
        if isChapter() {
            emojiString = "📋"
        }
        
        if mailEnabled {
            emojiString = emojiString + "📪"
        }
        
        if PDFEnabled {
            emojiString = emojiString + "📚"
        }
        
        return isChapter() ? emojiString + " " + name : name
    }
    
    func isChapter() -> Bool {
        return chapters.count == 0
    }
    
    func setChapterName(_ chapterName: String) {
        
        name = chapterName
    }
    
    func getJsonObject() -> NSDictionary {
        
        let childChaptersJsonObject:NSMutableArray = []
        
        for chapter in chapters {
            
            childChaptersJsonObject.add(chapter.getJsonObject())
        }
        
        let chapterJsonObject = [
            "id": id,
            "name": name,
            "htmlPage": htmlPage,
            "chapters": childChaptersJsonObject
        ] as [String:Any]
        
        
        return chapterJsonObject as NSDictionary
    }
    
}
