//
//  UserProfile+Helper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import PopupDialog

var user: Voter!
var userAvaURL: String!
var userName: String!
var userHomeLocationInString: String!
var userHomeLocationLat: Double!
var userHomeLocationLng: Double!
var userEmail: String!
var userUid: String!

let userDefaults = UserDefaults.standard

struct defaultsKeys {
    static let userAvaURL = "userAvaURL"
    static let userName = "userName"
    static let userHomeLocationInString = "userHomeLocationInString"
    static let userHomeLocationLat = "userHomeLocationLat"
    static let userHomeLocationLng = "userHomeLocationLng"
    static let userEmail = "userEmail"
    static let userUid = "userUid"
    static let newInviteForRoomUUID = "newInviteForRoomUUID"
}

class Universial {
    static func saveUserInfo() {
        /*
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.

        let downloadPicTask = session.dataTask(with: URL(string: userAvaURL)!) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        userDefaults.set(image: image, forKey: defaultsKeys.userAvatarImageAdd)
                        // Do something with your image.
                    } else {
                        //Default image
                        userDefaults.set(image: #imageLiteral(resourceName: "demoAvatar"), forKey: defaultsKeys.userAvatarImageAdd)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()*/ //The avatar is now saved as link, instead of downloaded data of image
        
        if let imageURL = URL(string: userAvaURL) {
            userDefaults.set(imageURL.absoluteString, forKey: defaultsKeys.userAvaURL)
        }
        
        userDefaults.set(userName, forKey: defaultsKeys.userName)
        //userDefaults.set(userHomeLocation, forKey: defaultsKeys.userHomeLocation)
        userDefaults.set(userEmail, forKey: defaultsKeys.userEmail)
        userDefaults.set(userUid, forKey: defaultsKeys.userUid)
    }
}
