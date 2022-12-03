//
//  ViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 10/26/22.
//

import UIKit

class SigninViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordFieldContainer: UIView!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var signUpUserLabel: UILabel!
    
    private var iconClick = true

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        passwordTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        emailTextField.layer.borderColor = UIColor(hexString: "#828282").cgColor
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.borderWidth = 1.0
        passwordFieldContainer.layer.borderColor = UIColor(hexString: "#828282").cgColor
        passwordFieldContainer.layer.cornerRadius = 5.0
        passwordFieldContainer.layer.borderWidth = 1.0
        
        let forgetPasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapForgetPassword(_:)))
        forgetPasswordLabel.addGestureRecognizer(forgetPasswordTapGesture)
        
        let signUpUserTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSignUpUser(_:)))
        signUpUserLabel.addGestureRecognizer(signUpUserTapGesture)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 140)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func validateLoginFields() -> Bool {
        if emailTextField.text!.isEmpty {
            return false
        }
        if passwordTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    @objc func onTapForgetPassword(_ sender: Any) {
        ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: "This feature is not available at the moment.")
    }
    
    @objc func onTapSignUpUser(_ sender: Any) {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: SignUpViewController.self)) as? SignUpViewController
        signUpViewController?.modalPresentationStyle = .fullScreen
        self.present(signUpViewController!, animated: true)
    }
    
    @IBAction func onTapShowPassword(_ sender: Any) {
        if iconClick {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        if validateLoginFields() {
            ProgressLoader.sharedInstance.showAlert(viewController: self, alertMessage: "Signing In, Please wait.")
            UserService.sharedInstance.loginUser(userName: emailTextField.text ?? "", password: passwordTextField.text ?? "") { response in
                DispatchQueue.main.async {
                    ProgressLoader.sharedInstance.dismissAlert(viewController: self) {
                        if response.responseStatus == .success {
                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                            let homeViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController
                            homeViewController?.modalPresentationStyle = .fullScreen
                            self.present(homeViewController!, animated: true)
                        }
                        else {
                            ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: "\(response.errorMessage ?? "Invalid Credentials")")
                        }
                    }
                }
            }
        }
        else {
            ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: "Please fill all required fields.")
        }
    }


}

