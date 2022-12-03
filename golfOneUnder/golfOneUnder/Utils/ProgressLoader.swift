//
//  ProgressLoader.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/29/22.
//

import Foundation
import UIKit

class ProgressLoader {
    static var sharedInstance = ProgressLoader()
    private var alertController: UIAlertController?
    ///Shows loading alert controller with user message
    func showAlert(viewController: UIViewController, alertMessage: String) {
        alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alertController?.view.addSubview(loadingIndicator)
        
        viewController.present(alertController!, animated: true)
        
    }
    
    ///Shows Information alert box with user message and ok button.
    func showAlertMessage(viewController: UIViewController, alertMessage: String) {
        alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
        
        alertController?.addAction(okAction)

        viewController.present(alertController!, animated: true)

    }
    
    ///Shows Information alert box with user message and ok button and a completion action to calling method.
    func showAlertMessage(viewController: UIViewController, alertMessage: String, onCompletion: @escaping (() -> ())) {
        alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                onCompletion()
            }
        
        alertController?.addAction(okAction)

        viewController.present(alertController!, animated: true)

    }
    
    ///Shows alert box with action button and cancel button.
    func showActionAlert(viewController: UIViewController, alertMessage: String, okActionText: String, onOkAction: @escaping (() -> ()), onCancelAction: @escaping (() -> ())) {
        alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionText, style: UIAlertAction.Style.default) { UIAlertAction in
            NSLog("\(okActionText)) Pressed")
            onOkAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
            NSLog("Cancel Pressed")
            onCancelAction()
        }
        
        alertController?.addAction(okAction)
        alertController?.addAction(cancelAction)

        viewController.present(alertController!, animated: true)
    }
    
    ///Shows warning alert box with red warning action button and cancel button.
    func showWarningAlert(viewController: UIViewController, alertMessage: String, okActionText: String, onOkAction: @escaping (() -> ()), onCancelAction: @escaping (() -> ())) {
        alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionText, style: UIAlertAction.Style.destructive) { UIAlertAction in
            NSLog("\(okActionText)) Pressed")
            onOkAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
            NSLog("Cancel Pressed")
            onCancelAction()
        }
        
        alertController?.addAction(okAction)
        alertController?.addAction(cancelAction)

        viewController.present(alertController!, animated: true)
    }
    
    ///dismisses alert box currently being displayed.
    func dismissAlert(viewController: UIViewController, dismissCallback: @escaping (() -> ())) {
        alertController?.dismiss(animated: true) {
            dismissCallback()
        }
    }
    
}
