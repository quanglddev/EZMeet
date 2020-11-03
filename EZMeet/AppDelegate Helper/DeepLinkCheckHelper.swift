//
//  DeepLinkCheckHelper.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit

extension AppDelegate {
    
    //THE DEFALUT WILL BE "EZMeet://invite/ssssssssssssshjhjhhhjhjss"
    func deepLinkCheck(url: URL) {
        //Deep link
        print(url)
        
        let urlString = url.absoluteString
        let queryArray = urlString.components(separatedBy: "/")
        print(queryArray)
        
        let query = queryArray[2]
        
        //Check if invite
        if query.range(of: "invite") != nil {
            let data = urlString.components(separatedBy: "/")
            if data.count >= 3 {
                let parameter = data[3]
                //This should be uuid of room
                userDefaults.set(parameter, forKey: defaultsKeys.newInviteForRoomUUID)
                //Remember to delete after joining
                print(parameter)
            }
        }
    }
    
}
