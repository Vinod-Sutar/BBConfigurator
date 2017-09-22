//
//  ChapterEditViewController.swift
//  SwiftTOC
//
//  Created by Vinod on 11/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class ChapterEditViewController: NSViewController {

    var currentEditChapter = Chapter()
    
    @IBOutlet var guidelineNameTextField: NSTextField!
    
    @IBOutlet var chapterNameTextField: NSTextField!
    
    @IBOutlet var tocChapterNameTextField: NSTextField!
    
    @IBOutlet var PDFEnabledButton: NSButton!
    
    @IBOutlet var mailEnabledButton: NSButton!
    
    @IBOutlet var recipientsTextField: NSTextField!
    
    @IBOutlet var subjectTextField: NSTextField!
    
    @IBOutlet var bodyTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guidelineNameTextField.stringValue = currentEditChapter.guideline.name
        chapterNameTextField.stringValue = currentEditChapter.name
        tocChapterNameTextField.placeholderString = currentEditChapter.name
        tocChapterNameTextField.stringValue = currentEditChapter.tocName
        
        mailEnabledButton.state = currentEditChapter.mailEnabled ? NSOnState : NSOffState
        PDFEnabledButton.state = currentEditChapter.PDFEnabled ? NSOnState : NSOffState
        
        setMailView()
    }
    
    
    @IBAction func textFieldEditDone(_ sender: NSTextField) {
                
        if sender == chapterNameTextField {
            
            currentEditChapter.setChapterName(chapterNameTextField.stringValue)
        }
        else if sender == tocChapterNameTextField {
            
            currentEditChapter.tocName = tocChapterNameTextField.stringValue
        }
        else if sender == recipientsTextField {
            
            recipientsTextField.stringValue = recipientsTextField.stringValue.replacingOccurrences(of: " ", with: "")
            recipientsTextField.stringValue = recipientsTextField.stringValue.replacingOccurrences(of: ",", with: ", ")
            
        }
        else if sender == subjectTextField {
            
        }
        else if sender == bodyTextField {
            
        }
        
        postChapterUpdatedNotification()
    }
    
    
    @IBAction func PDFEnabledClicked(_ sender: Any) {

        currentEditChapter.PDFEnabled = PDFEnabledButton.state == NSOnState ? true : false

        postChapterUpdatedNotification()
    }
    
    func setMailView() {
        
        recipientsTextField.isEnabled = currentEditChapter.mailEnabled
        subjectTextField.isEnabled = currentEditChapter.mailEnabled
        bodyTextField.isEnabled = currentEditChapter.mailEnabled
    }
    
    @IBAction func mailEnabledClicked(_ sender: Any) {
        
        currentEditChapter.mailEnabled = mailEnabledButton.state == NSOnState ? true : false
        
        setMailView()
        
        postChapterUpdatedNotification()
    }
    
    @IBAction func doneClicked(_ sender: Any) {
       
        
        
        postChapterUpdatedNotification()
    }
    
    func postChapterUpdatedNotification() {
        
        currentEditChapter.guideline.updateConnectedPeers()
        NotificationCenter.default.post(name: NSNotification.Name("GuidelineListUpdate"), object: nil)
    }
}

extension ChapterEditViewController : NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        
        tocChapterNameTextField.placeholderString = chapterNameTextField.stringValue
        
        
    }
}
