//
//  UserManager.swift
//  BBConfigurator
//
//  Created by Vinod on 23/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class UserManager: NSObject {

    static let shared = UserManager()
    
    var currentUser:User! = nil
        
    override init() {
        
    }
    
    func synchronize(_ user: User, remembered: Bool) {
        
        currentUser = user
        
        if remembered {
         
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(encodedData, forKey: "currentUser")
            UserDefaults.standard.synchronize()
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getCurrentUser() -> User! {
        
        return currentUser
    }
    
    func getRemeberedUser() -> User! {
        
        if UserDefaults.standard.object(forKey: "currentUser") != nil {
            
            let decodedData = UserDefaults.standard.object(forKey: "currentUser") as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! User
        }
        
        return nil
    }
    
    
    func reset() {
        
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
    }
}

class User: NSObject, NSCoding {
    
    let email: String!
    let password: String!
    
    let userId: String!
    let userName: String!
    
    
    init(_ email: String, password: String, userId: String, userName: String) {
        
        self.email = email
        self.password = password
        self.userId = userId
        self.userName = userName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let userId = aDecoder.decodeObject(forKey: "userId") as! String
        let userName = aDecoder.decodeObject(forKey: "userName") as! String
        self.init(email, password: password, userId: userId, userName: userName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(userName, forKey: "userName")
    }
    
    func documentPath() -> String {
        
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let folderPath = "\(documentDirectory)/BBConfigurator/\(self.email!)/"
        
        if FileManager.default.fileExists(atPath: folderPath) == false {
            
            do {
                
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
        return folderPath
    }
    
    func appsJsonPath() -> String {
        
        return "\(documentPath())apps.json"
    }
    
    func sendAppsJsonToPeers() {
        
        if FileManager.default.fileExists(atPath: appsJsonPath()) {
            
            MPCManager.shared.sendResourcesToPeers(appsJsonPath(), withName: "json--apps.json")
        }
    }
}
