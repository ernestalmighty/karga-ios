//
//  CartViewController.swift
//  GrainsmartKarga
//
//  Created by user on 16/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialCards
import Firebase
import CoreLocation

class CartViewController: UIViewController {

    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let profile = realm.objects(Profile.self).first
        var address = "Not set."
        
        if(profile != nil) {
            address = profile!.addressLine2 + " " + profile!.addressLine1
            getAdditionalFee()
        } else {
            self.totalAmountLabel.text = "--"
            self.deliveryFeeLabel.text = "--"
        }
        
        deliveryAddressLabel.text = address
    }
    
    @IBAction func onProceedButtonClicked(_ sender: Any) {
    }
    
    func getAdditionalFee() {
        let db = Firestore.firestore()
        let store = realm.objects(Store.self).first
        let profile = realm.objects(Profile.self).first
        let orders = realm.objects(ProductOrder.self)
        
        let ordersList = Array(orders)
        if(ordersList.count == 0) {
            self.totalAmountLabel.text = "--"
            self.deliveryFeeLabel.text = "--"
            return
        }
        
        let result = Array(realm.objects(ProductOrder.self))
        var totalAmount = result.reduce(0, {$0 + $1.price})
        
        if(store == nil) {
            return
        }
        
        if(store != nil) {
            db.collection("stores").document(store!.storeId)
                .collection("fees")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let displayName = document.data()["displayName"] as! String
                            let deliveryExtraPeso = document.data()["deliveryExtraPeso"] as! Double
                            let deliveryFeeEnabled = document.data()["deliveryFeeEnabled"] as! Bool
                            let deliveryFreeRadius = document.data()["deliveryFeeRadiusFree"] as! Double
                            var additionalFee = 0
                            
                            if(deliveryFeeEnabled) {
                                let userLocation = CLLocation(latitude: profile!.addressLat, longitude: profile!.addressLon)

                                let storeLocation = CLLocation(latitude: store!.lat, longitude: store!.lon)
                                let distance = userLocation.distance(from: storeLocation) / 1000
                                
                                if(Int(distance) > Int(deliveryFreeRadius)) {
                                    let additionalDistance = Int(distance) - Int(deliveryFreeRadius)
                                    additionalFee = Int(deliveryExtraPeso) * additionalDistance
                                }
                                
                                self.deliveryFeeLabel.text = String(additionalFee)
                                totalAmount += Float(additionalFee)
                            } else {
                                self.deliveryFeeLabel.text = "*after confirmation"
                            }
                            
                            self.totalAmountLabel.text = String(totalAmount)
                        }
                    }
            }
        } else {
            print("Please select a store.")
        }
    }
}
