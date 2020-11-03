//
//  LeftnDeleteRoomHelper.swift
//  EZMeet
//
//  Created by QUANG on 9/22/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import ChameleonFramework

extension ViewController {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print(rooms.count)
        print(indexPath.row)
        
        if let room = rooms[safe: indexPath.row] {
            if user.uid == room.admin.uid {
                //If the user is admin and editing, show delete room with confirmation
                let deleteRoom = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("YES I UNDERSTAND") {
                        //Delete the whole room (in all individuals and the room itself)
                        guard let voters = self.rooms[indexPath.row].voters else { return }
                        for participant in voters {
                            ref.child("users").child(participant.uid).child("rooms").child(self.rooms[indexPath.row].uuid).removeValue()
                        }
                        //MARK: CHANGE THIS TO MOVE TO TRASH, DELETING FOR NOW
                        ref.child("rooms").child(self.rooms[indexPath.row].uuid).removeValue()
                        
                        //Delete the cell instead of loading everything again
                        //self.getJoinedRoomsFromFirebase()
                        self.pollTableView.beginUpdates()
                        self.rooms.remove(at: indexPath.row)
                        self.pollTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.pollTableView.endUpdates()
                    }
                    alertView.addButton("DISMISS") {
                        //Dismiss
                    }
                    alertView.showWarning("DELETING ROOM!!!", subTitle: "EVERYTHING WILL BE ERASED INCLUDING ALL PARTICIPANTS")
                    
                })
                deleteRoom.backgroundColor = UIColor.flatRed()
                
                return [deleteRoom]
            }
            else { //For participants can only left the room
                let leaveRoom = UITableViewRowAction(style: .destructive, title: "Leave", handler: { (action, indexPath) in
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("YES I UNDERSTAND") {
                        //Delete the room in all individual
                        print(self.rooms[indexPath.row].uuid)
                        print(user.uid)
                        
                        ref.child("users").child(user.uid).child("rooms").child(self.rooms[indexPath.row].uuid).removeValue(completionBlock: { (error, ref) in
                            if error != nil {
                                print("error \(String(describing: error))")
                            }
                        })
                        
                        //Delete the cell instead of loading everything again
                        //self.getJoinedRoomsFromFirebase()
                        self.pollTableView.beginUpdates()
                        self.rooms.remove(at: indexPath.row)
                        self.pollTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.pollTableView.endUpdates()
                    }
                    alertView.addButton("DISMISS") {
                        //Dismiss
                    }
                    alertView.showWarning("LEAVING ROOM!!!", subTitle: "YOU WON'T BE ABLE TO JOIN UNLESS BEING INVITED AGAIN")
                    
                })
                leaveRoom.backgroundColor = UIColor.flatYellow()
                
                
                return [leaveRoom]
            }
        }
        return nil
    }
}
