//
//  Store.swift
//  GrainsmartKarga
//
//  Created by user on 9/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class Store {
    var storeId: String
    var name: String
    var address: String
    var lat: Double
    var lon: Double
    var contact: String
    var social: String
    var email: String
    var messenger: String
    
    init(storeId: String, name: String, address: String, lat: Double, lon: Double, contact: String, social: String, email: String, messenger: String) {
        self.storeId = storeId
        self.name = name
        self.address = address
        self.lat = lat
        self.lon = lon
        self.contact = contact
        self.social = social
        self.email = email
        self.messenger = messenger
    }
}
