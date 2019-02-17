//
//  ViewController.swift
//  OnTheMap
//
//  Created by makramia on 04/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    // MARK: Login
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        let udacitySignupURL = "https://www.udacity.com/account/auth#!/signup"
        if let url = URL(string: udacitySignupURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            self.presentAlertWithTitle(title: "Alert", message: "Username or Password can't be empty.", options: "OK", completion: { (option) in
                print("option: \(option)")})
            
        } else {
           
            guard let email = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            
            let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
            
             setUIEnabled(false)
            
            UdacityClient.sharedInstance().authenticateWithViewController(self, jsonBody: jsonBody) { (success,errorString) in
                DispatchQueue.main.async {
                    if success {
                        self.setUIEnabled(true)
                        self.completeLogin()
                    }else {
                        self.setUIEnabled(true)
                        self.displayError(errorString)
                        
                        self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                            print("option: \(option)")})
                        
                    }
                }
                
            }  
           
        }
    }
    
    private func completeLogin() {
      
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        
        
        print("success you have logined!")
}

}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            self.stopActivityIndicator()
        } else {
            loginButton.alpha = 0.5
            self.startActivityIndicator(.whiteLarge, location: self.loginButton.center)
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
           print(errorString)
        }
    }
    func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UI.LoginColorTop, UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        configureTextField(emailTextField)
        configureTextField(passwordTextField)
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UI.GreyColor
        textField.textColor = UI.BlueColor
        textField.tintColor = UI.BlueColor
        textField.delegate = self
    }
}


