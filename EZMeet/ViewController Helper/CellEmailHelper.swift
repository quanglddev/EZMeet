//
//  CellEmailHelper.swift
//  EZMeet
//
//  Created by QUANG on 8/2/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import SCLAlertView
import MessageUI

extension ViewController: PollTVCDelegate {
    func buttonDidClicked(email: String, roomName: String) {
        if !MFMailComposeViewController.canSendMail() {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            }
            alertView.showWarning("NO EMAIL IDENTIFIED", subTitle: "PLEASE SET UP YOUR EMAIL IN APPLE MAIL APP", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([email])
        composeVC.setSubject("QUESTION ABOUT \(roomName)")
        composeVC.setMessageBody("Hello World!", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
}
