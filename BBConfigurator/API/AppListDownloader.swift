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
