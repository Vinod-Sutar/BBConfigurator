//
//  MainViewController.swift
//  BBConfigurator
//
//  Created by BBI-M USER1033 on 21/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    let mpcManager:MPCManager = MPCManager()
    
    @IBOutlet var mainContainerView: NSView!
    
    @IBOutlet var deviceConnectedLabel: NSTextField!
    
    @IBOutlet var userNameLabel: NSTextField!
    
    @IBOutlet var organizationLabel: NSTextField!
    
    @IBOutlet var currentMainContainerViewController: NSViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mpcManager.delegate = self
        
        let loginViewController = self.storyboard?.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.mainViewController = self
        
        setMainContainerViewController(loginViewController)
        
    }
    
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
            
            userNameLabel.stringValue = UserManager.shared.getCurrentUser().userName
            organizationLabel.stringValue = "Börm Bruckmeier Infotech"
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func didUserValidatingComplete(_ user: User) {
        
        let guidelineListViewController = self.storyboard?.instantiateController(withIdentifier: "GuidelineListViewController") as! GuidelineListViewController
        
        self.performSelector(onMainThread: #selector(setMainContainerViewController), with: guidelineListViewController, waitUntilDone: false)
    }
}

extension MainViewController: MPCManagerDelegate {
    
    func didConnectedPeersListUpdated() {
        
        var connectedDeviceString = ""
        
        let connectedPeers = mpcManager.session.connectedPeers;
        
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
            
            //sendAppDataToConnectedDevices()
        }
    }
}

