//
//  VSCollectionViewItem.swift
//  BBConfigurator
//
//  Created by Vinod on 23/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class VSAppCollectionViewItem: NSCollectionViewItem {
    
    var app: App! = nil
    
    @IBOutlet var titleLabel: NSTextField!
    
    @IBOutlet var appImageView: AppImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getAppIconPath(_ user: User) -> String {
        
        let folderPath = user.documentPath() + "Images/"
        
        let filePath = folderPath + "appIcon_" + app.projectId + ".png"
        
        if FileManager.default.fileExists(atPath: folderPath) == false {
            
            do {
                
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
            }
        }
        
        return filePath
    }
    
    func setApp(app: App!) {
        
        if app != nil {
            
            titleLabel.stringValue = app.name
            appImageView.setApp(app: app)
        }
    }
}
