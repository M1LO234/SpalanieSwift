//
//  LoginViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 14/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.warningLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "fourthSegue", sender: self)
                }
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   

}
