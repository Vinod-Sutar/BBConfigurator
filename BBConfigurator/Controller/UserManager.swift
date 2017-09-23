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
        
    override init() {
        
    }
    
    func synchronize(_ user: User) {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: "currentUser")
        UserDefaults.standard.synchronize()
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getCurrentUser() -> User! {
        
        if UserDefaults.standard.object(forKey: "currentUser") != nil {
        
            let decodedData = UserDefaults.standard.object(forKey: "currentUser") as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! User
        }
        
        return nil
    }
    
    
    func reset() {
        
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
}
