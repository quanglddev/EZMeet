//
//  Navigation Helper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

extension ViewController {
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let roomDetailViewController = segue.destination as? DetailTVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRoomCell = sender as? PollTVC else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = pollTableView.indexPath(for: selectedRoomCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            print(indexPath.row)
            print(rooms.count) 
            let selectedRoom = rooms[indexPath.row]
            roomDetailViewController.room = selectedRoom
        case "info":
            return
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

}
