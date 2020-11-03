//
//  InvitationHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import PopupDialog

extension ViewController {
    func checkIfThereIsInvitation() {
        //Check if open by deeplink (thorugh external link)
        if let newInviteRoomUUID = userDefaults.string(forKey: defaultsKeys.newInviteForRoomUUID) {
            if newInviteRoomUUID != "" && !newInviteRoomUUID.isEmpty {
                //Receive an invite
                askIfWantToJoinRoom(uuidOfRoom: newInviteRoomUUID)
                //Clear the invitation
                userDefaults.set("", forKey: defaultsKeys.newInviteForRoomUUID)
            }
        }
    }
    
    
    func askIfWantToJoinRoom(uuidOfRoom: String) {
        // Prepare the popup assets
        let title = "YOU GOT AN INVITATION"
        let message = "Wow somebody invite you to go somewhere 🍿🍿🍿.\nDo you want to join them?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let btnYes = DefaultButton(title: "👍 YES OF COURSE 👍") {
            shouldRefresh = true
            
            //Run room update
            if (user) != nil && shouldRefresh {
                shouldRefresh = false
                self.getJoinedRoomsFromFirebase()
            }
            
            //Join the room
            ref.child("users").child(user.uid).child("rooms").child(uuidOfRoom).setValue("INVITED ROOM")
            ref.child("rooms").child(uuidOfRoom).child("voters").child(user.uid).setValue(user.name)
        }
        
        let btnCancel = CancelButton(title: "NO I DO NOT") {
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([btnYes, btnCancel])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}
