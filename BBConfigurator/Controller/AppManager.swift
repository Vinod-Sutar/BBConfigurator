//
//  AppManager.swift
//  BBConfigurator
//
//  Created by BBI-M USER1033 on 13/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class AppManager: NSObject {

    static let shared = AppManager()
    
    override init() {
        super.init()
    }
    
    func appList() -> [App]! {
     
        var apps: [App] = []
        
        
        
        if let filePath = getAppListJsonPath() ,
            FileManager.default.fileExists(atPath: filePath) {
            
            
            do {
                
                let fileURL = URL(fileURLWithPath: filePath)
                
                let data = try Data(contentsOf: fileURL)
                
                let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if jsonData is NSArray,
                    let appsArray = jsonData as? NSArray {
                    
                    for app in appsArray {
                        
                        let appItem = app as! NSDictionary
                        
                        let projectId = appItem["proj_id"] as! String
                        let uniqueId = appItem["unique_id"] as! String
                        let projectName = appItem["proj_name"] as! String
                        
                        let app = App(projectId, uniqueId: uniqueId, name: projectName)
                        
                        apps.append(app)
                    }
                }
            }
            catch {
                
            }
        }
        
        return apps
    }
    
    func saveAppList(apps: NSArray) {
        
        if let filePath = getAppListJsonPath() {
            
            let fileURL = URL(fileURLWithPath: filePath)
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: apps, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let appsJsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                
                try appsJsonString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                
            }
            catch {
                
            }
            
            if let user = UserManager.shared.getCurrentUser() {
                
                user.sendAppsJsonToPeers()
            }
        }
    }
    
    func getAppListJsonPath() -> String! {
        
        if let user = UserManager.shared.getCurrentUser() {
            
            let userDocumentPath = user.documentPath()
            
            return "\(userDocumentPath)apps.json"
        }
        
        return nil
    }
}
