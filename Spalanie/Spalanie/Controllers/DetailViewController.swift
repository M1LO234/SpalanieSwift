//
//  DetailViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 15/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var stanLicznikaLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    @IBOutlet weak var litryLabel: UILabel!
    @IBOutlet weak var stacjaLabel: UILabel!
    
    let db = Firestore.firestore()
    var data: String = ""
    var stan: Int = 0
    var cena: Float = 0.0
    var litry: Int = 0
    var stacja: String = ""
    var autoID: String = ""
    
    @IBAction func deletePressed(_ sender: UIButton) {
        db.collection("\((Auth.auth().currentUser?.email)!)").document(autoID).delete { (error) in
            if let e = error {
                print("Error removing document: \(e)")
            } else {
                print("Document successfully removed!")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = "Data tankowania: \(data)"
        stanLicznikaLabel.text = "Stan licznika: \(stan)"
        cenaLabel.text = "Cena za litr: \(cena)"
        litryLabel.text = "Zatankowane litry: \(litry)"
        stacjaLabel.text = "Stacja benzynowa: \(stacja)"
    }

}
