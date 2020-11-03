//
//  PollTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import MessageUI

protocol PollTVCDelegate
{
    func buttonDidClicked(email: String, roomName: String)
}

class PollTVC: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    //MARK: Properties
    var emailToContact: String!
    var delegate: PollTVCDelegate!
    
    //MARK: Outlets
    
    @IBOutlet weak var adminAvatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var admin: UILabel!
    @IBOutlet weak var numberOfVoters: UILabel!
    @IBOutlet weak var lastActivity: UILabel!
    
    //MARK: Actions
    
    @IBAction func contactThroughEmail(_ sender: UIButton) {
        if let email = emailToContact {
            if let roomName = title.text {
                self.delegate.buttonDidClicked(email: email, roomName: roomName)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        adminAvatar.setRounded()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
