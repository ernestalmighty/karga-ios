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
import MapKit
import CoreLocation
import GoogleMobileAds

class HomeViewController: UIViewController, StoreSelectionDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var homeNavigationItem: HomeNavigationItem!
    @IBOutlet weak var homeStoreView: UIView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeContactLabel: UILabel!
    @IBOutlet weak var storeSocialLabel: UILabel!
    @IBOutlet weak var productsContainerView: UIView!
    @IBOutlet weak var adBannerView: GADBannerView!
    
    let realm = try! Realm()
    let locationManager = CLLocationManager()
    
    var selectedStore: String = ""
    var deviceLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //adBannerView.adUnitID = "ca-app-pub-1965212949581065/2292269695"
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
        
        let store = self.realm.objects(Store.self).first
        let orders = realm.objects(ProductOrder.self)
        if (store == nil) {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled()
                && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse
                || CLLocationManager.authorizationStatus() == .authorizedAlways) {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                getStores()
            }
        } else {
            if orders.count == 0 {
                locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled()
                    && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse
                    || CLLocationManager.authorizationStatus() == .authorizedAlways) {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                } else {
                    getStores()
                }
            } else {
                updateSelectedStore(store!)
                self.performSegue(withIdentifier: "segueShowProducts", sender: self)
            }
        }
        
        let icon = UIImage(named: "HomeLogo")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 90, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.contentMode = .scaleAspectFit
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)

        homeNavigationItem.leftBarButtonItem = barButton
        
        let rightIconView = UIImageView(image: UIImage(named: "HomeRightLogo"))
        rightIconView.contentMode = .scaleAspectFit
        homeNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightIconView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        deviceLocation = CLLocation(latitude: CLLocationDegrees(locValue.latitude), longitude: CLLocationDegrees(locValue.longitude))
        
        getStores()
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let store = realm.objects(Store.self).first
        if (status == .denied || status == .notDetermined) && store == nil {
           getStores()
        }
    }
    
    func updateSelectedStore(_ store: Store) {
        try! realm.write {
            realm.add(store, update: .modified)
        }
        
        print(store.name)
        
        self.storeNameLabel.text = store.name
        self.storeAddressLabel.text = store.address
        self.storeSocialLabel.text = store.social
        self.storeContactLabel.text = store.contact
        
        self.selectedStore = store.storeId
    }
    
    func getStores() {
        let db = Firestore.firestore()
        db.collection("stores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var stores: [Store] = []
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
                    
                    stores.append(store)
                }
                
                
                if(self.deviceLocation != nil) {
                    var closestLocationDistance = -1
                    var closestStore: Store?
                    stores.forEach { (userStore) in
                        let storeLocation = CLLocation(latitude: CLLocationDegrees(userStore.lat), longitude: CLLocationDegrees(userStore.lon))
                        
                        let distance = self.deviceLocation!.distance(from: storeLocation)
                        if(closestLocationDistance < 0 || (Int(distance) < closestLocationDistance)) {
                            closestLocationDistance = Int(distance)
                            closestStore = userStore
                        }
                    }
                    
                    self.updateSelectedStore(closestStore!)
                } else {
                    self.updateSelectedStore(stores[0])
                }
                
                self.performSegue(withIdentifier: "segueShowProducts", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProducts" {
            let controller = segue.destination as! ProductCollectionViewController
            controller.storeId = self.selectedStore
        } else if segue.identifier == "segueShowStores" {
            let controller = segue.destination as! StoreTableViewController
            controller.delegate = self
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(!self.selectedStore.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func updateStoreSelection(withStore store: Store) {
        if self.selectedStore != store.storeId {
            let alert = UIAlertController(title: "Proceed to new store?", message: "Selecting another branch will clear items in your cart.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                
                let objects = self.realm.objects(ProductOrder.self)

                try! self.realm.write {
                    self.realm.delete(objects)
                }
                
                self.updateSelectedStore(store)
                
                if let vc = self.children.filter({$0 is ProductCollectionViewController}).first as? ProductCollectionViewController {
                    vc.storeId = store.storeId
                    vc.viewDidAppear(true)
                }
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Dismiss action"), style: .cancel, handler: { _ in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
