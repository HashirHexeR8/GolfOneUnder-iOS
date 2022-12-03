//
//  BaseViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/30/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    func logoutCurrentUser() {
        RangeFinderDeviceService.sharedInstance.disconnectDevice()
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let viewcontroller : UIViewController = onboardingStoryboard.instantiateViewController(withIdentifier: String(describing: SigninViewController.self)) as UIViewController
        self.view.window!.rootViewController = viewcontroller
        UserService.sharedInstance.logoutCurrentUser()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
