//
//  Location.swift
//  EZMeet
//
//  Created by QUANG on 7/28/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import os.log

class Location: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let inString = "inString"
        static let lat = "lat"
        static let lng = "lng"
    }
    
    //MARK: Properties
    var inString: String
    var lat: Double
    var lng: Double
    
    //MARK: Initialization
    init?(inString: String, lat: Double, lng: Double) {
        
        // Initialization should fail if there is no title or admin name.
        guard !inString.isEmpty else {
            return nil
        }
        
        self.inString = inString
        self.lat = lat
        self.lng = lng
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(inString, forKey: PropertyKey.inString)
        aCoder.encode(lat, forKey: PropertyKey.lat)
        aCoder.encode(lng, forKey: PropertyKey.lng)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let inString = aDecoder.decodeObject(forKey: PropertyKey.inString) as? String else {
            os_log("Unable to decode the inString.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let lat = aDecoder.decodeDouble(forKey: PropertyKey.lat)
        
        let lng = aDecoder.decodeDouble(forKey: PropertyKey.lng)
        
        self.init(inString: inString, lat: lat, lng: lng)
    }
}
