//
//  GuidelineListDownloader.swift
//  SwiftTOC
//
//  Created by BBI-M USER1033 on 18/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

protocol GuidelineListDownloaderDelegate {
    
    func didReceivedGuidelineList(_ app: App, guidelines: NSArray)
}

class GuidelineListDownloader: NSObject {
    
    static let shared = GuidelineListDownloader()
    
    let httpRequestManager = HTTPRequestManager()
    
    var app: App!

    var delegate:GuidelineListDownloaderDelegate?
    
    override init() {
        
        super.init()
        
        httpRequestManager.delegate = self
    }
    
    func downloadList(_ ofApp: App) {
        
        app = ofApp
        
        let parameter = [
            "proj_id": app.projectId
            ] as [String : String]
        
        let request = HTTPRequest("http://cpms.bbinfotech.com/CMS/handshake/cms_viewer/CMSoverviewAppRequestHandler.php", methodName: "getGuidelines", parameters: parameter as NSDictionary, namespace: "urn:CMSoverviewAppRequestHandler")
        
        httpRequestManager.sendRequest(request as URLRequest)
    }
}

extension GuidelineListDownloader : HTTPRequestManagerDelegate {
    
    func didDataReceived(_ response: Any?) {
        
        if let response = response as? NSArray {
            
            delegate?.didReceivedGuidelineList(app, guidelines: response)
        }
        else {
            
            didDataReceiveFailed()
        }
    }
    
    func didDataReceiveFailed() {
        
        print("Failed")
    }
}
