//
//  LoginViewController.swift
//  BBConfigurator
//
//  Created by Vinod on 23/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    var mainViewController: MainViewController!
    
    @IBOutlet var emailTextField: NSTextField!
    
    @IBOutlet var passwordTextField: NSSecureTextField!
    
    @IBOutlet var loginContentView: NSView!
    
    @IBOutlet var validatingContentView: NSView!
    
    @IBOutlet var textFieldContentView: LoginContentBackgroundView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let user = UserManager.shared.getCurrentUser() {
            
            setLoginContentViewVisiblilty(false)
            
            emailTextField.stringValue = user.email
            passwordTextField.stringValue = user.password

            loginClicked(user)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        setLoginContentViewVisiblilty(false)
        ValidateUser.shared.delegate = self
        ValidateUser.shared.validate(emailTextField.stringValue, password: passwordTextField.stringValue)
    }
    
    func setLoginContentViewVisiblilty(_ visible: Bool) {

        loginContentView.isHidden = !visible
        validatingContentView.isHidden = visible
        
        if visible == true {
            textFieldContentView.shake()
        }
    }
}

extension LoginViewController : ValidateUserDelegate {
    
    func didValidUser(_ valid: Bool, userId: String, userName: String) {

        if valid {
            
            let user = User(emailTextField.stringValue, password: passwordTextField.stringValue, userId: userId, userName: userName)
            
            UserManager.shared.synchronize(user)
            
            mainViewController.didUserValidatingComplete(user)
        }
        else {
            
            self.performSelector(onMainThread: #selector(setLoginContentViewVisiblilty), with: true, waitUntilDone: false)
        }
    }

}
