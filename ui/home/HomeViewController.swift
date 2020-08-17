//
//  HomeViewController.swift
//  GrainsmartKarga
//
//  Created by user on 9/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Firebase
import JJFloatingActionButton
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var homeNavigationItem: HomeNavigationItem!
    @IBOutlet weak var homeStoreView: UIView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeContactLabel: UILabel!
    @IBOutlet weak var storeSocialLabel: UILabel!
    @IBOutlet weak var productsContainerView: UIView!
    
    let realm = try! Realm()
    
    var selectedStore: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeNavigationItem.largeTitleDisplayMode = .never
        
        getStores()

        let leftIconView = UIImageView(image: UIImage(named: "HomeLogo"))
        leftIconView.contentMode = .scaleAspectFill
        leftIconView.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        homeNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIconView)
        
        let rightIconView = UIImageView(image: UIImage(named: "HomeRightLogo"))
        rightIconView.contentMode = .scaleAspectFill
        rightIconView.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        homeNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightIconView)
        
        homeStoreView.layer.shadowRadius = 1
        homeStoreView.layer.shadowOffset = .zero
        homeStoreView.layer.shadowOpacity = 0.2
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
                    
                    try! self.realm.write {
                        self.realm.add(store, update: .modified)
                    }
                    
                    self.storeNameLabel.text = displayName
                    self.storeAddressLabel.text = address
                    self.storeSocialLabel.text = social
                    self.storeContactLabel.text = contact
                    
                    self.selectedStore = document.documentID
                    
                    self.performSegue(withIdentifier: "segueShowProducts", sender: self)
                    
                    break
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProducts" {
            let controller = segue.destination as! ProductCollectionViewController
            controller.storeId = self.selectedStore
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(!self.selectedStore.isEmpty) {
            return true
        } else {
            return false
        }
    }
}
