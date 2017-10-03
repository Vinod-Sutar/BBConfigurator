//
//  DefaultViewController.swift
//  BBConfigurator
//
//  Created by Vinod on 01/10/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class DefaultViewController: NSViewController {

    @IBOutlet var guidelineImageView: VSGuidelineImageView!
        
    var currentEditGuideline: Guideline! = nil
    
    @IBOutlet var defaultContentView: DefaultContentView!
    
    @IBOutlet var iPhoneDefaultImageView: VSDefaultImageView!
    @IBOutlet var iPhone5DefaultImageView: VSDefaultImageView!
    
    @IBOutlet var iPadPortraitImageView: VSDefaultImageView!
    @IBOutlet var iPadPortrait2XImageView: VSDefaultImageView!
    
    @IBOutlet var iPadLandscapeDefaultImageView: VSDefaultImageView!
    @IBOutlet var iPadLandscape2XDefaultImageView: VSDefaultImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDefaultImages), name: NSNotification.Name(rawValue: "DefaultContentViewUpdate"), object: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guidelineImageView.currentGuideline = currentEditGuideline
        guidelineImageView.image = currentEditGuideline.getGuidelineIcon()
        defaultContentView.currentGuideline = currentEditGuideline
        
        iPhoneDefaultImageView.defaultImageType = .iPhone4
        iPhone5DefaultImageView.defaultImageType = .iPhone5AndAbove
        iPadPortraitImageView.defaultImageType = .iPadPortrait
        iPadPortrait2XImageView.defaultImageType = .iPadPortrait2x
        iPadLandscapeDefaultImageView.defaultImageType = .iPadLandscape
        iPadLandscape2XDefaultImageView.defaultImageType = .iPadLandscape2x
        
        
        iPhoneDefaultImageView.currentGuideline = currentEditGuideline
        iPhone5DefaultImageView.currentGuideline = currentEditGuideline
        iPadPortraitImageView.currentGuideline = currentEditGuideline
        iPadPortrait2XImageView.currentGuideline = currentEditGuideline
        iPadLandscapeDefaultImageView.currentGuideline = currentEditGuideline
        iPadLandscape2XDefaultImageView.currentGuideline = currentEditGuideline
        
        setDefaultImages()
    }
    
    func setDefaultImages() {
    
        iPhoneDefaultImageView.setDefaultImage()
        iPhone5DefaultImageView.setDefaultImage()
        iPadPortraitImageView.setDefaultImage()
        iPadPortrait2XImageView.setDefaultImage()
        iPadLandscapeDefaultImageView.setDefaultImage()
        iPadLandscape2XDefaultImageView.setDefaultImage()
    }
}
