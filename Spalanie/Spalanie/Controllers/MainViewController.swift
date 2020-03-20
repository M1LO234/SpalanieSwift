//
//  MainViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 14/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //extension to picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var stanLicznikaLabel: UITextField!
    @IBOutlet weak var zatankowaneLitryLabel: UITextField!
    @IBOutlet weak var cenaZaLitrLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var pickerStacji: UIPickerView!
    @IBOutlet weak var dodajStacjeButton: UIButton!
    @IBOutlet weak var wybierzStacjeLabel: UILabel!
    
//    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func infoPressed(_ sender: Any) {
        loadData()
        pickerStacji.reloadAllComponents()
        isInfoSelected = !isInfoSelected
        pickerStacji.isHidden = isInfoSelected
        dodajStacjeButton.isHidden = isInfoSelected
    }
    
    
    //na dole
    @IBAction func dodajPressed(_ sender: UIButton) {
        stacja = selected
        wybierzStacjeLabel.text = stacja
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = pickerData[row]
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "fifthSegue", sender: self)
                
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
    var pickerData: [String] = []
    let db = Firestore.firestore()
    var selected: String = ""
    var isInfoSelected = true
    var stacja: String? = ""
    
    @objc func checkAndDisplayErr(textfield: UITextField) {
        let pattern = "[0-9][.][0-9][0-9]"
        if cenaZaLitrLabel.text?.range(of: pattern, options: .regularExpression) == nil {
            warningLabel.text = "Nie prawidłowe dane"
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor.red
        } else {
            warningLabel.text = ""
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor.green
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let stan = stanLicznikaLabel.text, let litry = zatankowaneLitryLabel.text, let cena = cenaZaLitrLabel.text, let nazwa = stacja, let sender = Auth.auth().currentUser?.email{
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let now = df.string(from: datePicker.date)
            
            db.collection("\((Auth.auth().currentUser?.email)!)").addDocument(data: ["Data": now, "StanLicznika": stan, "ZatankowaneLitry": litry, "CenaZaLitr": cena, "NazwaStacji": nazwa, "User": sender]) { (error) in
                if let e = error {
                    print("Nie zapisano!, \(e)")
                } else {
                    print("Zapisano!")
                }
            }
            
        }
    }
    
    func loadData() {
        db.collection("\((Auth.auth().currentUser?.email)!)").addSnapshotListener{ (querySnapshot, error) in
            if let e = error {
                print("Error: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.pickerData = []
                    for doc in snapshotDocuments {
                        if doc.documentID == "Stacje"{
                            let data = doc.data()
                            if let lista = data["ListaStacji"] as? [String] {
                                for stacja in lista {
                                    self.pickerData.append(stacja)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = false
        sendButton.backgroundColor = UIColor.red
        
        self.pickerStacji.delegate = self
        self.pickerStacji.dataSource = self
        
        pickerStacji.isHidden = true
        dodajStacjeButton.isHidden = true
        
        loadData()
        
        cenaZaLitrLabel.addTarget(self, action: #selector(checkAndDisplayErr(textfield:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seventhSegue" {
            let destinationVC = segue.destination as! StacjaViewController
            destinationVC.listaStacji = pickerData
         
        }
    }

}
