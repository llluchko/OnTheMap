//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/23/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
   
    var keyboardOnScreen = false
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        
        activityIndicator.hidesWhenStopped = true
        overlayView.hidden = true
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: UIConstants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: UIConstants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: UIConstants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: UIConstants.Selectors.KeyboardDidHide)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(sender: AnyObject) {
        userDidTapView(self)
        
        if usernameTextField.text == "" {
            alert("Enter Username!")
            return
        }
        
        if passwordTextField.text == "" {
            alert("Enter Password")
            return
        }
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.view.bringSubviewToFront(self.overlayView)
            self.overlayView.hidden = false
        }
        
        UdacityClient.sharedInstance().loginWith(usernameTextField.text!, password: passwordTextField.text!) { (result, error) in
            if (result == "success") {
                self.completeLogin()
            } else {
                performUIUpdatesOnMain() {
                    self.alert(error!)
                }
            }
        }
    }
    
    private func completeLogin() {
        UdacityClient.sharedInstance().getUserInfo { (result, error) in
            if result == "success" {
                performUIUpdatesOnMain {
                    self.debugTextLabel.text = ""
                    self.setUIEnabled(true)
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain() {
                    self.alert(error!)
                }
            }
        }
    }
    

    func alert(text: String) {
        performUIUpdatesOnMain {
            let controller = UIAlertController(title: nil, message: text, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            self.overlayView.hidden = true
        }
    }
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}


extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func configureUI() {
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UIConstants.Colors.LoginColorTop, UIConstants.Colors.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.backgroundColor = UIConstants.Colors.GreyColor
        textField.textColor = UIConstants.Colors.BlueColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tintColor = UIConstants.Colors.BlueColor
        textField.delegate = self
    }
}


extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}