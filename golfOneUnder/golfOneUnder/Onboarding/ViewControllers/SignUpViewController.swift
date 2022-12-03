//
//  SignUpViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/23/22.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userFullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordFieldContainer: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordFieldContainer: UIView!
    @IBOutlet weak var signUserLabel: UILabel!
    
    private var isShowPassword = true
    private var errorString = "Please fill all the required fields."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        userFullNameTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        userNameTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        passwordTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        confirmPasswordTextField.setPlaceHolderColor(UIColor(hexString: "#828282"))
        emailTextField.layer.borderColor = UIColor(hexString: "#828282").cgColor
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.borderWidth = 1.0
        userFullNameTextField.layer.borderColor = UIColor(hexString: "#828282").cgColor
        userFullNameTextField.layer.cornerRadius = 5.0
        userFullNameTextField.layer.borderWidth = 1.0
        userNameTextField.layer.borderColor = UIColor(hexString: "#828282").cgColor
        userNameTextField.layer.cornerRadius = 5.0
        userNameTextField.layer.borderWidth = 1.0
        passwordFieldContainer.layer.borderColor = UIColor(hexString: "#828282").cgColor
        passwordFieldContainer.layer.cornerRadius = 5.0
        passwordFieldContainer.layer.borderWidth = 1.0
        confirmPasswordFieldContainer.layer.borderColor = UIColor(hexString: "#828282").cgColor
        confirmPasswordFieldContainer.layer.cornerRadius = 5.0
        confirmPasswordFieldContainer.layer.borderWidth = 1.0
        
        let signInUserTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSignInUser))
        signUserLabel.addGestureRecognizer(signInUserTapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 70)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func validateSignupFields() -> Bool {
        if emailTextField.text!.isEmpty {
            errorString = "Please fill all the required fields."
            return false
        }
        if userFullNameTextField.text!.isEmpty {
            errorString = "Please fill all the required fields."
            return false
        }
        if userNameTextField.text!.isEmpty {
            errorString = "Please fill all the required fields."
            return false
        }
        if passwordTextField.text!.isEmpty {
            errorString = "Please fill all the required fields."
            return false
        }
        if confirmPasswordTextField.text!.isEmpty {
            errorString = "Please fill all the required fields."
            return false
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            errorString = "Password and Confirm Password fields must match."
            return false
        }
        return true
    }
    
    @objc func onTapSignInUser(_ sender: Any) {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: SigninViewController.self)) as? SigninViewController
        signInViewController?.modalPresentationStyle = .fullScreen
        self.present(signInViewController!, animated: true)
    }
    
    @IBAction func onTapShowPassword(_ sender: Any) {
        if isShowPassword {
            passwordTextField.isSecureTextEntry = false
            confirmPasswordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = false
        }
        isShowPassword = !isShowPassword
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        if validateSignupFields() {
            ProgressLoader.sharedInstance.showAlert(viewController: self, alertMessage: "Creating account, Please wait.")
            let signUpDTO = UserSignUpRequestDTO(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", name: userFullNameTextField.text ?? "", username: userNameTextField.text ?? "")
            UserService.sharedInstance.signupUser(userSignupInfo: signUpDTO, onResponse: { response in
                DispatchQueue.main.async {
                    ProgressLoader.sharedInstance.dismissAlert(viewController: self) {
                        if response.responseStatus == .success {
                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                            let homeViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController
                            homeViewController?.modalPresentationStyle = .fullScreen
                            self.present(homeViewController!, animated: true)
                        }
                        else {
                            ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: "\(response.errorMessage ?? "Unable to create an account at this time.")")
                        }
                    }
                }
            })
        }
        else {
            ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: errorString)
        }
    }
}
