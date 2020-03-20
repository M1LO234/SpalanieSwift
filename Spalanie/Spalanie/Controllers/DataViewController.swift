//
//  DataViewController.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 15/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit
import Firebase

class DataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var touched = 0
    let db = Firestore.firestore()
    
    var dane: [DataToSend] = []
    var autoIDArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadData()
        
        tableView.register(UINib(nibName: "DataCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "sixthSegue" {
               let destinationVC = segue.destination as! DetailViewController
            if touched >= 0 && dane.count > 0{
                destinationVC.data = dane[touched].data
                destinationVC.stan = dane[touched].stanLicznika
                destinationVC.cena = dane[touched].cenaZaLitr
                destinationVC.litry = dane[touched].zatankowaneLitry
                destinationVC.stacja = dane[touched].stacja
                destinationVC.autoID = autoIDArray[touched]
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
           }
       }
    
    func loadData() {
        db.collection("\((Auth.auth().currentUser?.email)!)").order(by: "Data", descending: true).addSnapshotListener { (querySnapshot, error) in
            self.dane = []
            self.autoIDArray = []
            if let e = error {
                print("Issue retrieving data! \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        self.autoIDArray.append(doc.documentID)
                        let data = doc.data()
                        if let sender = data["User"] as? String, let dataTank = data["Data"] as? String, let cena = data["CenaZaLitr"] as? String, let nazwa = data["NazwaStacji"] as? String, let stan = data["StanLicznika"] as? String, let litry = data["ZatankowaneLitry"] as? String {
                            let newData = DataToSend(data: dataTank, stanLicznika: Int(stan)!, zatankowaneLitry: Int(litry)!, cenaZaLitr: Float(cena)!, stacja: nazwa)
                            self.dane.append(newData)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension DataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dane.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! DataCell
        cell.DataLabel.text = dane[indexPath.row].data
        cell.StacjaLabel.text = dane[indexPath.row].stacja
        cell.cenaLabel.text = "\((dane[indexPath.row].cenaZaLitr)*Float(dane[indexPath.row].zatankowaneLitry))"
        return cell
    }
}

extension DataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touched = indexPath.row
        performSegue(withIdentifier: "sixthSegue", sender: self)
        
    }
}
