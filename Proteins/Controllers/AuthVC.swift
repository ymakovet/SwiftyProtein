//
//  AuthVC.swift
//  Proteins
//
//  Created by Ruslan NAUMENKO on 2/10/19.
//  Copyright © 2019 UNIT Factory. All rights reserved.
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
        \(NSLocalizedString("Identify yourself", comment: "set in code"))
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
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: NSLocalizedString("Identify yourself", comment: "set in code")) {
            [unowned self] (succes, error) in
            DispatchQueue.main.async {
                if succes {
                    self.performSegue(withIdentifier: "toTableView", sender: self)
                }
                else {
                    if !(error!.localizedDescription == "Canceled by user.") && !(error!.localizedDescription == "Fallback authentication mechanism selected.") {
                        self.showAlertController(NSLocalizedString("Authentication Failed", comment: "set in code"))
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
