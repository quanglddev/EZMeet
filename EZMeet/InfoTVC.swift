//
//  InfoTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import SCLAlertView
import Social
import os.log
import MessageUI

class InfoTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        loadUserInfo()
    }
    
    func loadUserInfo() {
        DispatchQueue.main.async {
            if let str = userDefaults.string(forKey: defaultsKeys.userAvaURL) {
                if let avaURL = URL(string: str) {
                    self.avatarImageView.sd_setImage(with: avaURL)
                    self.avatarImageView.setRounded()
                }
            }
            if let name = userDefaults.string(forKey: defaultsKeys.userName) { self.lblName.text = name }
            if let contact = userDefaults.string(forKey: defaultsKeys.userEmail) { self.lblContact.text = contact }
            if let address = userDefaults.string(forKey: defaultsKeys.userHomeLocationInString) { self.lblAddress.text = address }
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
        }
        if indexPath.row == 0 && indexPath.section == 0 {
            //About
            //Open web (my facebook for now)
            let url = URL(string: "https://www.facebook.com/crzQag")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else if indexPath.row == 1 && indexPath.section == 0 {
            //Help and feedback (open mail)
            //sendMail()
            if !MFMailComposeViewController.canSendMail() {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("OK") {
                }
                alertView.showWarning("NO EMAIL IDENTIFIED", subTitle: "PLEASE SET UP YOUR EMAIL IN APPLE MAIL APP", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
                return
            }
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["quang.elit@gmail.com"])
            composeVC.setSubject("REPORT || SUGGESTION")
            composeVC.setMessageBody("Hello World!", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        else if indexPath.row == 2 && indexPath.section == 0 {
            //Share the app
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("FACEBOOK") {
                self.openFacebookComposer()
            }
            alertView.addButton("TWITTER") {
                self.openTwitterComposer()
            }
            alertView.addButton("CANCEL", action: {
                //Ignore
            })
            alertView.showSuccess("SHARE", subTitle: "PLEASE CHOOSE YOUR FAVORITE")
        }
        else if indexPath.row == 0 && indexPath.section == 1 {
            //Clear cache
            //Log out (delete all userDefaults)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES CLEAR ALL") {
                self.clearAllData()
            }
            alertView.addButton("NO") {
                //Ignore
            }
            alertView.showWarning("ARE YOU SURE?", subTitle: "ARE YOU REALLY REALLY SURE?", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
        }
        else if indexPath.row == 1 && indexPath.section == 1 {
            //Log out (delete all userDefaults)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES PLEASE LOG OUT") {
                userDefaults.set("", forKey: defaultsKeys.userHomeLocationInString)
            }
            alertView.addButton("NO") {
                //Ignore
            }
            alertView.showWarning("ARE YOU SURE?", subTitle: "ARE YOU REALLY REALLY SURE?", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
        }
    }
}
