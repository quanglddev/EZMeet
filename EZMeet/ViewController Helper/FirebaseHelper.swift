//
//  FirebaseHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

var ref: DatabaseReference!
//var _refHandle: DatabaseHandle!
//var storageRef: StorageReference!
fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
var pollsFromFirebase: [DataSnapshot]! = []

extension ViewController {
    
    func signedInStatus(isSignedIn: Bool) {
        if isSignedIn {
            configureDatabase()
            //configureStorage()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        /*
        if let uid = userDefaults.string(forKey: defaultsKeys.userUid) {
            _refHandle = ref.child("users").child(uid).child("rooms").observe(.childAdded, with: { (snapshot) in
                pollsFromFirebase.append(snapshot)
                //let nameOfAddedPoll = snapshot.value
                print(snapshot.value ?? "NO NAME")
            })
        }*/
    }
    /*
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }*/
    
    /*
    func createMeetingRoom() {
        ref.child("rooms").childByAutoId().setValue("YES MEETING")
    }*/
    
    func createUserProfile() {
        /*
        if let photoData = UIImageJPEGRepresentation(user.avatar!, 0.8) {
            let imagePath = "avatars/" + /*Auth.auth().currentUser!.uid*/ uniqueID + ".jpg"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.child(imagePath).putData(photoData, metadata: metaData, completion: { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                ref.child("users").child(uniqueID).child("avatar").setValue(storageRef.child((metaData.path)!).description)
                print(storageRef.child((metaData.path)!).description)
            })
        }*/
        ref.child("users").child(userUid).child("avaURL").setValue(user.avaURL)
        ref.child("users").child(userUid).child("name").setValue(user.name)
        ref.child("users").child(userUid).child("homeLocation").child("inString").setValue(user.homeLocation.inString)
        ref.child("users").child(userUid).child("homeLocation").child("lat").setValue(user.homeLocation.lat)
        ref.child("users").child(userUid).child("homeLocation").child("lng").setValue(user.homeLocation.lng)
        ref.child("users").child(userUid).child("email").setValue(user.email)
        
        //endOfWork()
    }
}
