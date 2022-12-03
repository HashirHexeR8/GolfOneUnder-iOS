//
//  SettingsPresenterViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import UIKit

class SettingsPresenterViewController: BaseViewController {

    @IBOutlet weak var delegeAccountButton: UIView!
    @IBOutlet weak var logoutButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            }
        
        let deleteAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteUser))
        delegeAccountButton.addGestureRecognizer(deleteAccountTapGesture)
        
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutUser))
        logoutButton.addGestureRecognizer(logoutTapGesture)
    }
    
    @objc func deleteUser() {
        
        ProgressLoader.sharedInstance.showWarningAlert(viewController: self, alertMessage: "This action will permenantly delete all your personal data from golf one finder database. Are you sure you want to continure?", okActionText: "Delete") {
            ProgressLoader.sharedInstance.showWarningAlert(viewController: self, alertMessage: "Are you sure you want to continue?\nThis action is irreversible.", okActionText: "OK") {
                ProgressLoader.sharedInstance.showAlert(viewController: self, alertMessage: "Deleting profile.")
                UserService.sharedInstance.deleteUserProfile { response in
                    DispatchQueue.main.async {
                        ProgressLoader.sharedInstance.dismissAlert(viewController: self) {
                            if response.responseStatus == .success {
                                self.dismiss(animated: true)
                                self.logoutCurrentUser()
                            }
                            else {
                                ProgressLoader.sharedInstance.showAlertMessage(viewController: self, alertMessage: response.errorMessage!)
                            }
                        }
                    }
                }
            } onCancelAction: {}

        } onCancelAction: {}
    }
    
    @objc func logoutUser() {
        ProgressLoader.sharedInstance.showWarningAlert(viewController: self, alertMessage: "Are you sure you want to logout?", okActionText: "Logout") {
            self.dismiss(animated: true)
            self.logoutCurrentUser()
            
        } onCancelAction: {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
