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

    @IBOutlet weak var touchIDBtn: UIButton!
    
    private let context = LAContext()
    var isProtectionSet = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let imageName = (context.biometryType == .faceID ? "face-id" : "Touch-ID-White")
            touchIDBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            touchIDBtn.setImage(UIImage(named: "passcode"), for: .normal)
        }
        else {
            isProtectionSet = false
            self.performSegue(withIdentifier: "toTableView", sender: self)
        }
    }
    
    private func login(completion: @escaping () -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Identify yourself") {
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
            completion()
        }
    }
    
    @IBAction func touchIDBtn(_ sender: UIButton) {
        touchIDBtn.isEnabled = false
        
        login {
            DispatchQueue.main.async {
                self.touchIDBtn.isEnabled = true
            }
        }
    }
    
}

//extension ViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//}

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

