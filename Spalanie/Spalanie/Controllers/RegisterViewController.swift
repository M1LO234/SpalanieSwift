//
//  RegisterViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 14/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.warningLabel.text = e.localizedDescription
                } else {
                    //Navigate to next controller
                    self.performSegue(withIdentifier: "secondSegue", sender: self)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    

}
