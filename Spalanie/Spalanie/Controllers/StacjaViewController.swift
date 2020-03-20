//
//  StacjaViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 16/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class StacjaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaStacji.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listaStacji[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touched = indexPath.row
        usunButton.isHidden = false
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var usunButton: UIButton!
    
    @IBAction func usunPressed(_ sender: UIButton) {
        db.collection("\((Auth.auth().currentUser?.email)!)").document("Stacje").updateData(["ListaStacji": FieldValue.delete()]) { (error) in
                if let e = error {
                    print("Error removing document: \(e)")
                } else {
                    print("Document successfully removed!")
                    self.listaStacji.remove(at: self.touched)
                self.db.collection("\((Auth.auth().currentUser?.email)!)").document("Stacje").setData(["ListaStacji":self.listaStacji])
                    self.tableView.reloadData()
                }
        }
        
        
        
        
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
        listaStacji.append(textField.text!)
        db.collection("\((Auth.auth().currentUser?.email)!)").document("Stacje").setData(["ListaStacji":listaStacji])
        tableView.reloadData()
    }
    
    var listaStacji: [String] = []
    let db = Firestore.firestore()
    var touched = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        addButton.isHidden = true
        usunButton.isHidden = true
        
        tableView.reloadData()
        
        textField.addTarget(self, action: #selector(checkIfEmpty(textfield:)), for: .editingChanged)
        
    }

    @objc func checkIfEmpty(textfield: UITextField) {
        if textField.text! == "" {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
}
