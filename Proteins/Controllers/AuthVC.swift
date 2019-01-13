//
//  ViewController.swift
//  Proteins
//
//  Created by Adilyam TILEGENOVA on 12/6/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthVC: UIViewController {

    @IBOutlet weak var identifyLabel: UILabel!
    @IBOutlet weak var touchIDBtn: UIButton!
    
    private var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        identifyLabel.text = """
        Identify yourself
        ⬇️
        """
        
        reloadData()
    }
    
    func reloadData() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let imageName = (context.biometryType == .faceID ? "faceID" : "touchID")
            touchIDBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            touchIDBtn.setImage(UIImage(named: "passcode"), for: .normal)
        }
        else {
            self.performSegue(withIdentifier: "toTableView", sender: self)
        }
        
    }
    
    private func login(completion: @escaping () -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Identify yourself") {
            [unowned self] (succes, error) in
            DispatchQueue.main.async {
                if succes {
                    self.performSegue(withIdentifier: "toTableView", sender: self)
                }
                else {
                    if !(error!.localizedDescription == "Canceled by user.") && !(error!.localizedDescription == "Fallback authentication mechanism selected.") {
                        self.showAlertController("Authentication Failed")
                    }
                }

                self.context = LAContext()
                completion()
            }
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
