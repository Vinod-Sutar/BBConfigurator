//
//  AppListDownloader.swift
//  SwiftTOC
//
//  Created by BBI-M USER1033 on 18/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

protocol AppListDownloaderDelegate {
    
    func didReceivedAppList(_ apps: [App])
}

class AppListDownloader: NSObject {
    
    static let shared = AppListDownloader()
    
    let httpRequestManager = HTTPRequestManager()
    
    var delegate:AppListDownloaderDelegate?
    
    override init() {
        
        super.init()
        
        httpRequestManager.delegate = self
    }
    
    func downloadList(_ ofUser: User) {
        
        let parameter = [
            "UserId": ofUser.userId
            ] as [String : String]
        
        let request = HTTPRequest("http://cpms.bbinfotech.com/CMS/handshake/cms_viewer/CMSoverviewAppRequestHandler.php", methodName: "getlistofGuidelineappProjects", parameters: parameter as NSDictionary, namespace: "urn:CMSoverviewAppRequestHandler")
        
        httpRequestManager.sendRequest(request as URLRequest)
    }
}

extension AppListDownloader : HTTPRequestManagerDelegate {
    
    func didDataReceived(_ response: Any?) {
        
        if let response = response as? NSArray {
            
            var appArray: [App] = []
            
            for app in response {
                
                let appItem = app as! NSDictionary
                
                let projectId = appItem["proj_id"] as! String
                let uniqueId = appItem["unique_id"] as! String
                let projectName = appItem["proj_name"] as! String
                
                let app = App(projectId, uniqueId: uniqueId, name: projectName)
                
                appArray.append(app)
            }
            
            if let user = UserManager.shared.getCurrentUser() {
                
                let userDocumentPath = user.documentPath()
                
                let filePath = "\(userDocumentPath)apps.json"
                
                let fileURL = URL(fileURLWithPath: filePath)
                
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    let appsJsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                    
                    try appsJsonString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                    
                }
                catch {
                    
                }
                
                if let user = UserManager.shared.getCurrentUser() {
                    
                    user.sendAppsJsonToPeers()
                }
             }
            
            delegate?.didReceivedAppList(appArray)
            
        }
        else {
            
            didDataReceiveFailed()
        }
    }
    
    func didDataReceiveFailed() {
        
        print("Failed")
    }
}
