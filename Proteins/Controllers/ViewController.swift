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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("here")
            let imageName = (context.biometryType == .faceID ? "face-id" : "Touch-ID-White")
            touchIDBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        else {
            touchIDBtn.isHidden = true
            login(completion: {})
        }

    }
    
    private func login(completion: () -> Void) {
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
        }
    }
    
    @IBAction func touchIDBtn(_ sender: UIButton) {
        touchIDBtn.isEnabled = false
        
        login {
            self.touchIDBtn.isEnabled = true
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

