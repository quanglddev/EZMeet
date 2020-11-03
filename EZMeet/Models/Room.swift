//
//  Poll.swift
//  EZMeet
//
//  Created by QUANG on 7/28/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import os.log

class Room: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let admin = "admin"
        static let voters = "voters"
        static let meetLocation = "meetLocation"
        static let notes = "notes"
        static let type = "type"
        static let isPrivate = "isPrivate"
        static let uuid = "uuid"
        static let latestActivity = "latestActivity"
    }
    
    //MARK: Properties
    var title: String
    var admin: Voter
    var voters: [Voter]?
    var meetLocation: Location
    var notes: String?
    var type: String
    var isPrivate: Bool
    var uuid: String
    var latestActivity: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Polls")
    
    //MARK: Initialization
    init?(title: String, admin: Voter, voters: [Voter]?, meetLocation: Location, notes: String?, type: String, isPrivate: Bool, uuid: String, latestActivity: Int) {
        
        // Initialization should fail if there is no title or admin name.
        guard !title.isEmpty else {
            return nil
        }
        
        self.title = title
        self.admin = admin
        self.voters = voters
        self.meetLocation = meetLocation
        self.notes = notes
        self.type = type
        self.isPrivate = isPrivate
        self.uuid = uuid
        self.latestActivity = latestActivity
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(admin, forKey: PropertyKey.admin)
        aCoder.encode(voters, forKey: PropertyKey.voters)
        aCoder.encode(meetLocation, forKey: PropertyKey.meetLocation)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(isPrivate, forKey: PropertyKey.isPrivate)
        aCoder.encode(uuid, forKey: PropertyKey.uuid)
        aCoder.encode(latestActivity, forKey: PropertyKey.latestActivity)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The title is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let admin = aDecoder.decodeObject(forKey: PropertyKey.admin) as? Voter else {
            os_log("Unable to decode the admin.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let voters = aDecoder.decodeObject(forKey: PropertyKey.voters) as? [Voter]
        
        let meetLocation = aDecoder.decodeObject(forKey: PropertyKey.meetLocation) as! Location
        
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        guard let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String else {
            os_log("Unable to decode the type.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let isPrivate = aDecoder.decodeBool(forKey: PropertyKey.isPrivate)
        
        guard let uuid = aDecoder.decodeObject(forKey: PropertyKey.uuid) as? String else {
            os_log("Unable to decode the uuid.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let latestActivity = aDecoder.decodeInteger(forKey: PropertyKey.latestActivity)
        
        // Must call designated initializer.
        self.init(title: title, admin: admin, voters: voters, meetLocation: meetLocation, notes: notes, type: type, isPrivate: isPrivate, uuid: uuid, latestActivity: latestActivity)
    }
}
