//
//  MainViewController.swift
//  BBConfigurator
//
//  Created by BBI-M USER1033 on 21/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    
    
    @IBOutlet var mainContainerView: NSView!
    
    @IBOutlet var logoutButton: NSButton!
    
    @IBOutlet var deviceConnectedLabel: NSTextField!
    
    @IBOutlet var userNameLabel: NSTextField!
    
    @IBOutlet var organizationLabel: NSTextField!
    
    @IBOutlet var currentMainContainerViewController: NSViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        MainViewManager.shared.delegate = self
        
        MPCManager.shared.delegate = self
        
        showLoginView()
    }
    
    func showLoginView() {
        
        let loginViewController = self.storyboard?.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.mainViewController = self
        
        setMainContainerViewController(loginViewController)
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        UserManager.shared.reset()
        showLoginView()
        
        logoutButton.isHidden = true
        userNameLabel.stringValue = ""
        organizationLabel.stringValue = ""
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func didUserValidatingComplete(_ user: User) {
                
        let appListViewController = self.storyboard?.instantiateController(withIdentifier: "AppListViewController") as! AppListViewController
        
        self.performSelector(onMainThread: #selector(setMainContainerViewController), with: appListViewController, waitUntilDone: false)
    }
}

extension MainViewController: MPCManagerDelegate {
    
    func didConnectedPeersListUpdated() {
        
        var connectedDeviceString = ""
        
        let connectedPeers = MPCManager.shared.session.connectedPeers;
        
        if connectedPeers.count == 0 {
            
        }
        else {
            
            connectedDeviceString = connectedDeviceString.appending("Device connected: ")
            
            for peerID in connectedPeers {
                
                if peerID == connectedPeers.first && peerID == connectedPeers.last
                {
                    connectedDeviceString = connectedDeviceString.appending("\(peerID.displayName).")
                }
                else if peerID == connectedPeers.first
                {
                    connectedDeviceString = connectedDeviceString.appending("\(peerID.displayName)")
                }
                else if peerID == connectedPeers.last
                {
                    connectedDeviceString = connectedDeviceString.appending(" and \(peerID.displayName).")
                }
                else
                {
                    connectedDeviceString = connectedDeviceString.appending(", \(peerID.displayName)")
                }
                
                OperationQueue.main.addOperation (){
                    
                    self.deviceConnectedLabel.stringValue = connectedDeviceString
                }
            }
            
            if let user = UserManager.shared.getCurrentUser() {
                
                user.sendAppsJsonToPeers()
            }
        }
    }
}


extension MainViewController: MainViewManagerDelegate {
 
    func setMainContainerViewController(_ viewController: NSViewController) {
        
        if currentMainContainerViewController != nil {
            
            currentMainContainerViewController.view.removeFromSuperview()
            currentMainContainerViewController.removeFromParentViewController()
        }
        
        self.addChildViewController(viewController)
        viewController.view.frame = mainContainerView.frame
        mainContainerView.addSubview(viewController.view)
        currentMainContainerViewController = viewController
        
        if viewController is LoginViewController {
            
        }
        else {
            
            logoutButton.isHidden = false
            userNameLabel.stringValue = UserManager.shared.getCurrentUser().userName
            organizationLabel.stringValue = "Börm Bruckmeier Infotech"
        }
        
        
    }
}

