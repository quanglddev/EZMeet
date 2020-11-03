//
//  File.swift
//  EZMeet
//
//  Created by QUANG on 10/1/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import SCLAlertView

extension ParticipationDetailTVC {
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let kickParticipant = UITableViewRowAction(style: .destructive, title: "Kick", handler: { (action, indexPath) in
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES I UNDERSTAND") {
                //Delete the person from the room and his/her rooms node
                guard let voter = self.participatedVoters[safe: indexPath.row] else { return }
                guard let roomUID = self.room?.uuid else { return }
                ref.child("users").child(voter.uid).child("rooms").child(roomUID).removeValue()
            
                //MARK: CHANGE THIS TO MOVE TO TRASH, DELETING FOR NOW
                ref.child("rooms").child(roomUID).child("voters").child(voter.uid).removeValue()
                
                //Delete the cell instead of loading everything again
                //self.getJoinedRoomsFromFirebase()
                self.tableView.beginUpdates()
                self.participatedVoters.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
            alertView.addButton("DISMISS") {
                //Dismiss
            }
            alertView.showWarning("KICKING \(self.participatedVoters[indexPath.row].name))!!!", subTitle: "Alleluja!")
            
        })
        kickParticipant.backgroundColor = UIColor.flatRed()
        
        return [kickParticipant]
    }
}
