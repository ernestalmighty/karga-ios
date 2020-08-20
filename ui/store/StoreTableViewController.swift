//
//  StoreTableViewController.swift
//  GrainsmartKarga
//
//  Created by user on 19/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class StoreTableViewController: UITableViewController {

    @IBOutlet var storeTableView: UITableView!
    
    let realm = try! Realm()
    
    var storeDataSource: [Store] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStores()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = StoreTableViewCell()
        
        let store = storeDataSource[indexPath.row]
        
        if let storeCell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as? StoreTableViewCell {
            storeCell.configureStore(store: store)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            storeCell.tag = indexPath.row
            storeCell.addGestureRecognizer(tap)
            
            cell = storeCell
        }
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let getTag = sender?.view?.tag else { return }
        
        if let navController = presentingViewController as? UINavigationController {
            let storeSelected = storeDataSource[getTag]
            let presenter = navController.topViewController as! HomeViewController
            presenter.selectedStore = storeSelected.storeId
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func getStores() {
        let db = Firestore.firestore()
        db.collection("stores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let storeId = document.documentID
                    let displayName = document.data()["displayName"] as! String
                    let lon = document.data()["lon"] as! Double
                    let lat = document.data()["lat"] as! Double
                    let contact = document.data()["contact"] as! String
                    let social = document.data()["social"] as! String
                    let address = document.data()["address"] as! String
                    let messenger = document.data()["messenger"] as! String
                    let email = document.data()["email"] as! String
                    
                    let store = Store()
                    store.name = displayName
                    store.address = address
                    store.contact = contact
                    store.social = social
                    store.messenger = messenger
                    store.email = email
                    store.lat = lat
                    store.lon = lon
                    store.storeId = storeId
                    
                    self.storeDataSource.append(store)
                }
                
                self.storeTableView.reloadData()
            }
        }
    }
}
