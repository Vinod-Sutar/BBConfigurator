//
//  MainViewManager.swift
//  BBConfigurator
//
//  Created by Vinod on 24/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

protocol MainViewManagerDelegate {
    
    func setMainContainerViewController(_ viewController: NSViewController)
}

class MainViewManager: NSObject {

    static let shared = MainViewManager()
    
    var delegate:MainViewManagerDelegate?
 
    func setMainContainerViewController(_ viewController: NSViewController) {
        
        self.delegate?.setMainContainerViewController(viewController)
    }
    
}
