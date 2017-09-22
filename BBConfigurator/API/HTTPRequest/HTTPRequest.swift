//
//  HTTPRequest.swift
//  SwiftTOC
//
//  Created by BBI-M USER1033 on 18/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class HTTPRequest: NSMutableURLRequest {

    init(_ urlString: String, methodName: String, parameters: NSDictionary, namespace: String) {
        
        super.init(url: URL(string: urlString)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted) 
            
            let parameterString = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            let paramString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns5511:\(methodName) xmlns:ns5511=\"http://tempuri.org\"><Data xsi:type=\"xsd:string\">\(parameterString)</Data></ns5511:\(methodName)></SOAP-ENV:Body></SOAP-ENV:Envelope>"
            
            let paramStringLength = "\(paramString.lengthOfBytes(using: String.Encoding.utf8))"
            
            self.cachePolicy = .reloadIgnoringLocalCacheData
            
            self.httpBody = paramString.data(using: String.Encoding.utf8)
            
            self.httpMethod = "POST"
            
            self.addValue("urn:CMSoverviewAppRequestHandler", forHTTPHeaderField: "namespace")
            
            self.addValue(methodName, forHTTPHeaderField: "message")
            
            self.addValue("text/xml; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            self.addValue(paramStringLength, forHTTPHeaderField: "Content-Length")
            
            self.addValue("\(namespace)#\(methodName)", forHTTPHeaderField: "SOAPAction")
            
            self.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        }
        catch
        {
            print("Error -> \(error)")
        }
        
        //{ &quot;unique_id&quot; : &quot;ENAS260&quot;}
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}
