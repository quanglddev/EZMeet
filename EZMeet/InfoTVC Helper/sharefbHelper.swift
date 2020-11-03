//
//  sharefbHelper.swift
//  EZMeet
//
//  Created by QUANG on 8/2/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import MessageUI
import SCLAlertView
import Social

extension InfoTVC {
    func openFacebookComposer() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText("SHARE WITH FACEBOOK")
            fbShare.add(UIImage(named: "AppIcon60x60"))
            self.present(fbShare, animated: true, completion: nil)
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            alertView.showError("Accounts", subTitle: "Please login to a Facebook account to share.")
        }
    }
    
    func openTwitterComposer() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let tweetShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText("SHARE WITH TWITTER")
            tweetShare.add(UIImage(named: "AppIcon60x60"))
            self.present(tweetShare, animated: true, completion: nil)
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            alertView.showError("Accounts", subTitle: "Please login to a Twitter account to tweet.")
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
