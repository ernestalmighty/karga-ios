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
    @IBOutlet weak var cartNavigationItem: UINavigationItem!
    
    var additionalFee = 0
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let result = Array(realm.objects(ProductOrder.self))
        let totalAmount = result.reduce(0, {$0 + $1.price})
        
        let profile = realm.objects(Profile.self).first
        var address = "Not set."
        
        if(profile != nil) {
            address = profile!.addressLine2 + " " + profile!.addressLine1
            getAdditionalFee()
        } else {
            self.totalAmountLabel.text = String(totalAmount)
            self.deliveryFeeLabel.text = "--"
        }
        
        deliveryAddressLabel.text = address
    }
    
    func getOrderGroups() -> [OrderGroup] {
        let orders = realm.objects(ProductOrder.self)
        var orderGroupDataSource: [OrderGroup] = []
        let groupedItems = Dictionary(grouping: orders, by: {$0.variantId})
        
        for (_, value) in groupedItems {
            let orderGroup = OrderGroup(variantId: value[0].variantId, quantity: value.count, variant: value[0].variant, category: value[0].category, imageUrl: value[0].iconUrl, price: value[0].price)
            
            orderGroupDataSource.append(orderGroup)
        }
        
        return orderGroupDataSource
    }
    
    @IBAction func onProceedButtonClicked(_ sender: Any) {
        let objects = realm.objects(ProductOrder.self)
        if(objects.count == 0) {
            let alertController = UIAlertController(title: "Checkout", message:
                "Your don't have any orders set", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Proceed to order?", message: "Please review your order and delivery address before proceeding.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Default action"), style: .default, handler: { _ in
                       self.proceedToOrder()
                   }))
                   
                   alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Dismiss action"), style: .cancel, handler: { _ in
                   }))
                   
                   self.present(alert, animated: true, completion: nil)
        }
    }
    
    func proceedToOrder() {
        let db = Firestore.firestore()
        let store = realm.objects(Store.self).first
        let profile = realm.objects(Profile.self).first
        
        if(profile != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            let deviceId = UIDevice.current.identifierForVendor?.uuidString
            
            let totalDate = DateFormatter()
            totalDate.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let now = totalDate.string(from: Date())
            
            let reference = db.collection("stores")
                .document(store!.storeId)
                .collection("orders")
                .document(currentDate)
                .collection(deviceId!)
                .document()
            
            let orderGroups = getOrderGroups()
            var totalAmount = Float(0)
            
            var htmlBuilder = ""
            
            for orderGroup in orderGroups {
                htmlBuilder.append("<p><b>Order Detail:</b></p>")
                let tempAmount = Float(orderGroup.quantity) * orderGroup.price
                totalAmount += tempAmount
                
                let order = [
                    "Category": orderGroup.category,
                    "Variant": orderGroup.variant,
                    "Price": String(orderGroup.price),
                    "Quantity": String(orderGroup.quantity),
                    "Total Amount": String(tempAmount)
                    ] as [String : String]
                
                for (key, value) in order {
                    htmlBuilder.append("<tr><td>")
                    htmlBuilder.append(key)
                    htmlBuilder.append("</td><td>")
                    htmlBuilder.append(value)
                    htmlBuilder.append("</td></tr>")
                }
                
                htmlBuilder.append("</table>")
                
                db.collection("stores").document(store!.storeId).collection("orders")
                    .document(currentDate)
                    .collection(deviceId!)
                    .document(reference.documentID)
                    .collection("list")
                    .addDocument(data: order)
            }
            
            totalAmount += Float(self.additionalFee)
            
            var summaryBulder = ""
            summaryBulder.append("<p><b>Summary</b></p>")
            summaryBulder.append("<table>")
            let totalMap = [
                "Total Amount": String(totalAmount),
                "Delivery Fee": String(self.additionalFee),
                "Date": now,
                "Client Name": profile!.name,
                "Contact": profile!.contact,
                "Address 1": profile!.addressLine1,
                "Address 2": profile!.addressLine2,
                "Delivery Instructions": profile!.instructions,
                "Status": "unconfirmed"
                ] as [String : String]
            
            for (key, value) in totalMap {
                summaryBulder.append("<tr><td>")
                summaryBulder.append(key)
                summaryBulder.append("</td><td>")
                summaryBulder.append(value)
                summaryBulder.append("</td></tr>")
            }
            
            summaryBulder.append("</table>")
            summaryBulder.append(htmlBuilder)
            
            let messageMap = [
                "subject": "You have a new order!",
                "text": "Grainsmart " + store!.name,
                "html": summaryBulder
            ]
            
            let mailMap = [
                "to": "kargadeliveryph@gmail.com",
                "message": messageMap,
                "cc": store!.email
                ] as [String : Any]
            
            db.collection("mail")
                .document()
                .setData(mailMap)
            
            db.collection("stores").document(store!.storeId).collection("orders")
                .document(currentDate)
                .collection(deviceId!)
                .document(reference.documentID)
                .setData(totalMap)
            
            let objects = realm.objects(ProductOrder.self)

            try! realm.write {
                realm.delete(objects)
            }
            
            if let vc = children.filter({$0 is CartTableViewController}).first as? CartTableViewController {
                vc.viewDidAppear(true)
                self.totalAmountLabel.text = "--"
                self.deliveryFeeLabel.text = "--"
            }
            
            let historyDateFormatter = DateFormatter()
            historyDateFormatter.dateFormat = "yyyy-MM-dd hh:ss a"
            let historyCurrentDate = historyDateFormatter.string(from: Date())
            
            let orderHistory = OrderHistory()
            orderHistory.id = reference.documentID
            orderHistory.totalAmount = totalAmount
            orderHistory.date = historyCurrentDate
            
            try! realm.write {
                realm.add(orderHistory)
            }
            
            let alertController = UIAlertController(title: "Checkout", message:
                "You have successfully placed your order. Please wait for our confrimation.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Checkout", message:
                "Your delivery address is not set.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
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
                                self.additionalFee = additionalFee
                                totalAmount += Float(additionalFee)
                            } else {
                                self.deliveryFeeLabel.text = "0.0"
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
