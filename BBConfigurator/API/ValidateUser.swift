//
//  ValidateUser.swift
//  BBConfigurator
//
//  Created by Vinod on 23/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa


protocol ValidateUserDelegate {
    
    func didValidUser(_ valid: Bool, userId: String, userName: String)
}


class ValidateUser: NSObject {

    static let shared = ValidateUser()
    
    let httpRequestManager = HTTPRequestManager()
    
    var delegate:ValidateUserDelegate?
    
    override init() {
        
        super.init()
        
        httpRequestManager.delegate = self
    }
    
    func validate(_ email: String, password: String) {
    
        let parameter = [
            "userName": email,
            "userPassword": password
            ] as [String : String]
        
        let request = HTTPRequest("http://cpms.bbinfotech.com/CMS/handshake/cms_viewer/CMSoverviewAppRequestHandler.php", methodName: "validateUser", parameters: parameter as NSDictionary, namespace: "urn:CMSoverviewAppRequestHandler")
        
        httpRequestManager.sendRequest(request as URLRequest)
        
    }
}



extension ValidateUser : HTTPRequestManagerDelegate {
    
    func didDataReceived(_ response: Any?) {
        
        if let response = response as? NSDictionary,
            case let reponseCode = response["QueryStatus"] as! String,
            case let userId = response["UserId"],
            case let userName = response["UserName"],
            reponseCode == "200" {
            
            delegate?.didValidUser(true,  userId: userId as! String, userName: userName as! String)
        }
        else {
            
            didDataReceiveFailed()
        }
    }
    
    func didDataReceiveFailed() {
        
        print("Failed")
        
        delegate?.didValidUser(false, userId: "", userName: "")
    }
}
