//
//  LoadSaveHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/28/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import os.log

extension ViewController {
    
    func loadSample() {
        /*
        let myLocation = Location(inString: "Buildings 34T, Hoàng Đạo Thúy, Trung Hoà, Cầu Giấy, Hà Nội, Vietnam", lat: 21.008621, lng: 105.802954)!
        let desLocation = Location(inString: "Wellspring International Bilingual School, Ngõ 135 Bồ Đề, Bồ Đề, Hanoi, Vietnam", lat: 21.039096, lng: 105.874177)!
        let voter1 = Voter(avatar: #imageLiteral(resourceName: "Iron Man"), name: "Quang Luong", homeLocation: myLocation, email: "quangld00@gmail.com", uid: "jdsjfhafhajhjajda")!
        
        let poll1 = Poll(title: "YES MEETING", admin: voter1, voters: [voter1], meetLocation: desLocation, notes: "Come here baby 🍿🍿🍿", latestMeetingLocation: Location(inString: "nowhere", lat: 0, lng: 0))!
        
        polls += [poll1, poll1, poll1]*/
    }
    
    func saveRooms() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(rooms, toFile: Room.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Rooms successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rooms...", log: OSLog.default, type: .error)
        }
    }
    
    
    func loadRooms() -> [Room]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Room.ArchiveURL.path) as? [Room]
    }
    
    func loadUserInfo() {
        guard let locationInString = userDefaults.string(forKey: defaultsKeys.userHomeLocationInString) else { return }
        if locationInString.isEmpty {
            return
        }
        let locationLat = userDefaults.double(forKey: defaultsKeys.userHomeLocationLat)
        let locationLng = userDefaults.double(forKey: defaultsKeys.userHomeLocationLng)
        let savedLocation = Location(inString: locationInString, lat: locationLat, lng: locationLng)!
        
        guard let name = userDefaults.string(forKey: defaultsKeys.userName) else { return }
        guard let email = userDefaults.string(forKey: defaultsKeys.userEmail) else { return }
        guard let uid = userDefaults.string(forKey: defaultsKeys.userUid) else { return }
        
        if let avaURL = userDefaults.string(forKey: defaultsKeys.userAvaURL) {
            user = Voter(avaURL: avaURL, name: name, homeLocation: savedLocation, email: email, uid: uid)
        }
        else {
            user = Voter(avaURL: "", name: name, homeLocation: savedLocation, email: email, uid: uid)
        }
    }
}
