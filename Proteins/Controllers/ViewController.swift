//
//  ViewController.swift
//  Proteins
//
//  Created by Adilyam TILEGENOVA on 12/6/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var touchIDBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = LAContext()
        var error: NSError?
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            touchIDBtn.isHidden = true
            
            if let err = error {
                switch err.code{
                case LAError.Code.biometryNotEnrolled.rawValue:
                    showAlertController(err.localizedDescription,
                                        "User is not enrolled")
                case LAError.Code.passcodeNotSet.rawValue:
                    showAlertController(err.localizedDescription,
                                        "A passcode has not been set")
                case LAError.Code.biometryNotAvailable.rawValue:
                    showAlertController(err.localizedDescription,
                                        "Biometric authentication not available")
                default:
                    showAlertController(err.localizedDescription,
                                        "Unknown error")
                }
            }
        }
        
        textField.delegate = self
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = ""
//        authWithTouchID()
    }

    @IBAction func sendPassBtnPressed(_ sender: UIButton) {
        loginBtn.isEnabled = false
        if let txt = textField.text {
            if txt == "1597" {
                performSegue(withIdentifier: "toTableView", sender: self)
            }
            else {showAlertController("Invalid password")}
        }
        loginBtn.isEnabled = true
    }
    
    
    @IBAction func touchIDBtn(_ sender: UIButton) {
        touchIDBtn.isEnabled = false
        let context = LAContext()
        let reason = "Identify yourself"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            (succes, error) in
            if succes {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toTableView", sender: self)
                }
            }
            else {
                if !(error!.localizedDescription == "Canceled by user.") && !(error!.localizedDescription == "Fallback authentication mechanism selected.") {
                    self.showAlertController("Authentication Failed")
                }
            }
        }
        touchIDBtn.isEnabled = true
    }
    
//    private func authWithTouchID() {
//        let context = LAContext()
//        var error: NSError?
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Authenticate with Touch ID"
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
//                (succes, error) in
//                if succes {
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "toTableView", sender: self)
//                    }
//                }
//                else {
//                    if (error!.localizedDescription == "Canceled by user.") || (error!.localizedDescription == "Fallback authentication mechanism selected."){
//                        DispatchQueue.main.async {
//                            self.pass = true
//                        }
//                    }
//                    else {
//                        self.showAlertController("Touch ID Authentication Failed")
//                        DispatchQueue.main.async {
//                            self.pass = true
//                        }
//                    }
//                }
//            }
//        }
//        else {
//            self.pass = true
//        }
//    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertController(_ message: String, _ title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
