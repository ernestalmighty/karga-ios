//
//  Profile.swift
//  GrainsmartKarga
//
//  Created by user on 17/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import RealmSwift

// Dog model
class Profile: Object {
    @objc dynamic var profileId = ""
    @objc dynamic var name = ""
    @objc dynamic var contact: String = ""
    @objc dynamic var addressLine1: String = ""
    @objc dynamic var addressLine2: String = ""
    @objc dynamic var instructions: String = ""
    @objc dynamic var addressLat: Double = 0.0
    @objc dynamic var addressLon: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "profileId"
    }
}
