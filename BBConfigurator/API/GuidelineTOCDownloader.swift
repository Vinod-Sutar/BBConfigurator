//
//  GuidelineTOCDownloader.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa


protocol GuidelineTOCDownloaderDelegate {
    
    func didReceivedGuidelineTOC(_ guideline: Guideline, rootChapters: NSArray)
}

class GuidelineTOCDownloader: NSObject {

    static let shared = GuidelineTOCDownloader()
    
    let httpRequestManager = HTTPRequestManager()
    
    var guideline: Guideline!
    
    var delegate:GuidelineTOCDownloaderDelegate?
    
    override init() {
        
        super.init()
        
        httpRequestManager.delegate = self
    }
    
    func downloadTOC(_ ofGuideline: Guideline) {
        
        guideline = ofGuideline
        
        let parameter = [
            "unique_id": guideline.uniqueId
            ] as [String : String]
        
        let request = HTTPRequest("http://cpms.bbinfotech.com/CMS/handshake/cms_viewer/CMSoverviewAppRequestHandler.php", methodName: "refreshTOCfile", parameters: parameter as NSDictionary, namespace: "urn:CMSoverviewAppRequestHandler")
        
        httpRequestManager.sendRequest(request as URLRequest)
    }
}

extension GuidelineTOCDownloader : HTTPRequestManagerDelegate {
    
    func didDataReceived(_ response: Any?) {
        
        if let response = response as? NSDictionary,
            case let reponseCode = response["QueryStatus"] as! String,
            case let tocURLPath = response["toc_link"] as! String,
            reponseCode == "200" {
            
            let config: URLSessionConfiguration = URLSessionConfiguration.default
            
            config.requestCachePolicy = .reloadIgnoringLocalCacheData;
            
            config.timeoutIntervalForRequest = 30;
            
            let session: URLSession = URLSession(configuration: config)
            
            let task = session.dataTask(with: URL(string: tocURLPath)!, completionHandler: {(data, response, error) -> Void in
                
                if error == nil
                {
                    if data == nil {
                        
                        print("TOC nil received")
                    }
                    else {
                        
                        do {
                            
                            let tocData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            
                            if let tocData = tocData as? NSArray {
                                
                                self.delegate?.didReceivedGuidelineTOC(self.guideline, rootChapters: tocData)
                            }
                        }
                        catch {
                            
                            print("Error -> \(error)")
                        }
                    }
                }
                else {
                    
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
                
            })
            
            task.resume()
        }
        else {
            
            didDataReceiveFailed()
        }
    }
    
    func didDataReceiveFailed() {
        
        print("Failed")
    }
}
