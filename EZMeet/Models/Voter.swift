//
//  Voter.swift
//  EZMeet
//
//  Created by QUANG on 7/28/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import os.log

class Voter: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let avaURL = "avaURL"
        static let name = "name"
        static let homeLocation = "homeLocation"
        static let email = "email"
        static let uid = "uid"
    }
    
    //MARK: Properties
    var avaURL: String?
    var name: String
    var homeLocation: Location
    var email: String
    var uid: String
    
    //MARK: Initialization
    init?(avaURL: String?, name: String, homeLocation: Location, email: String, uid: String) {
        
        // Initialization should fail if there is no title or admin name.
        guard !name.isEmpty || !email.isEmpty else {
            return nil
        }
        
        self.avaURL = avaURL
        self.name = name
        self.homeLocation = homeLocation
        self.email = email
        self.uid = uid
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(avaURL, forKey: PropertyKey.avaURL)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(homeLocation, forKey: PropertyKey.homeLocation)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(uid, forKey: PropertyKey.uid)
    }
    
        
    required convenience init?(coder aDecoder: NSCoder) {
        let avaURL = aDecoder.decodeObject(forKey: PropertyKey.avaURL) as? String
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let homeLocation = aDecoder.decodeObject(forKey: PropertyKey.homeLocation) as! Location

        guard let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String else {
            os_log("Unable to decode the email.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let uid = aDecoder.decodeObject(forKey: PropertyKey.uid) as? String else {
            os_log("Unable to decode the uid.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(avaURL: avaURL, name: name, homeLocation: homeLocation, email: email, uid: uid)
    }
    

}
