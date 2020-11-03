//
//  ParticipationDetailTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit

class ParticipationDetailTVC: UITableViewController {
    
    var room: Room?
    var participatedVoters = [Voter]()

    @IBAction func btnReturn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views to get voters location.
        if let room = room {
            participatedVoters = room.voters!
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participatedVoters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: participationCellID, for: indexPath) as! ParticipationTVC
        
        let person = participatedVoters[indexPath.row]
        cell.avatarImageView.sd_setImage(with: URL(string: person.avaURL ?? ""))
        cell.lblName.text = person.name
        cell.lblAddress.text = "⼛ Confidential Information ⼛"
        if let room = room {
            if !room.isPrivate {
                cell.lblAddress.text = person.homeLocation.inString
            }
        }
        
        return cell
    }
}
