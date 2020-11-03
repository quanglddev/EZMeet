//
//  ClearCacheHelper.swift
//  EZMeet
//
//  Created by QUANG on 8/2/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import os.log
import SCLAlertView

extension InfoTVC {
    func saveRooms(rooms: [Room]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(rooms, toFile: Room.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Rooms successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rooms...", log: OSLog.default, type: .error)
        }
    }
    
    
    func clearAllData() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("YES CLEAR CACHE") {
            let emptyRoom = [Room]()
            self.saveRooms(rooms: emptyRoom)
        }
        alertView.addButton("NO") {
            //Ignore
        }
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
        }
        alertView.showWarning("ARE YOU SURE?", subTitle: "ARE YOU REALLY REALLY SURE?", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
    }
}
