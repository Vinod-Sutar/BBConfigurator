//
//  HTTPRequestManager.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

protocol HTTPRequestManagerDelegate {
    
    func didDataReceived(_ response: Any?)
    
    func didDataReceiveFailed()
}

class HTTPRequestManager: NSObject {
    
    var responseString:String!
    
    var currentElement = ""
    
    var delegate:HTTPRequestManagerDelegate?
    
    var retryCount = 0
    
    var request: URLRequest!
    
    func sendRequest(_ request: URLRequest) {

        self.request = request
        
        retryCount = 0
        
        retryDownload()
    }
    
    func retryDownload() {
        
        if retryCount > 5 {
            
            print("Failed after retrying for \(retryCount) times")
        }
        else {
            
            retryCount = retryCount + 1
            
            let config: URLSessionConfiguration = URLSessionConfiguration.default
            
            config.requestCachePolicy = .reloadIgnoringLocalCacheData;
            
            config.timeoutIntervalForRequest = 30;
            
            let session: URLSession = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                
                if error == nil
                {
                    if data == nil {
                        
                        print("Data nil received")
                        self.retryDownload()
                    }
                    else {
                        
                        let xmlParser = XMLParser(data: data!)
                        
                        xmlParser.delegate = self
                        
                        if xmlParser.parse() {
                            
                        }
                        else {
                            
                            print("Parse failed.")
                            self.retryDownload()
                        }
                        
                    }
                }
                else {
                    
                    print("Error: \(String(describing: error?.localizedDescription))")
                    self.retryDownload()
                }
                
            })
            
            task.resume()
        }
    }
}

extension HTTPRequestManager : XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "return" {
            
            responseString = ""
        }
        
        currentElement = elementName
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElement == "return" {
            
            responseString = responseString.appending(string)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if responseString != nil {
            
            let jsonData = responseString.data(using: String.Encoding.utf8)
            
            do {
                
                let responseDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
             
                delegate?.didDataReceived(responseDictionary)
            }
            catch {
                
                print("Error -> \(error)")
                retryDownload()
            }
        }
    }
}
