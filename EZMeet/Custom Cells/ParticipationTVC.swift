//
//  ParticipationTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit

let participationCellID = "participationCell"

class ParticipationTVC: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if avatarImageView.image != nil {
            avatarImageView.setRounded()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
