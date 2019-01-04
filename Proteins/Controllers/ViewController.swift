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

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    private var pass: Bool = false {
        didSet {
            if pass {
                label.isHidden = false
                textField.isHidden = false
                btn.isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = ""
        label.isHidden = true
        textField.isHidden = true
        btn.isHidden = true
        authWithTouchID()
    }

    @IBAction func sendPassBtnPressed(_ sender: UIButton) {
        btn.isEnabled = false
        if let txt = textField.text {
            if txt == "1597" {
                performSegue(withIdentifier: "toTableView", sender: self)
            }
            else {showAlertController("Invalid password")}
        }
        btn.isEnabled = true
    }
    
    private func authWithTouchID() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (succes, error) in
                if succes {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toTableView", sender: self)
                    }
                }
                else {
                    if (error!.localizedDescription == "Canceled by user.") || (error!.localizedDescription == "Fallback authentication mechanism selected."){
                        DispatchQueue.main.async {
                            self.pass = true
                        }
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                    }
                }
            }
        }
        else {
            self.pass = true
        }
    }
    
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
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
