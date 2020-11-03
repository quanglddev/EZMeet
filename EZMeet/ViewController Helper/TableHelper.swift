//
//  TableHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableViewController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: roomCellID, for: indexPath) as! PollTVC
        
        
        let room = self.rooms[indexPath.row]
        
        cell.title.text = room.title.uppercased()
        cell.admin.text = room.admin.name
        if room.admin.uid == user.uid {
            cell.adminAvatar.sd_setImage(with: URL(string: user.avaURL ?? ""))
        }
        else {
            cell.adminAvatar.sd_setImage(with: URL(string: room.admin.avaURL ?? ""))
        }
        
        if (room.voters?.count)! > 1 {
            cell.numberOfVoters.text = "You and \((room.voters?.count)! - 1) others"
        }
        else {
            cell.numberOfVoters.text = "Only you joined"
        }
        cell.delegate = self
        cell.emailToContact = room.admin.email
        cell.lastActivity.text = getLastActivity(timeStamp: room.latestActivity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func getLastActivity(timeStamp: Int) -> String {
        let x = timeStamp / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(x))
        let elapsed = Date().timeIntervalSince(date)
        var arrayOfTime = [Int]()
        
        
        let seconds = Int(elapsed)
        arrayOfTime += [seconds]
        
        
        let minutes = seconds / 60
        arrayOfTime += [minutes]
        
        if minutes >= 60 {
            let hours = minutes / 60
            arrayOfTime += [hours]
            
            
            if hours >= 24 {
                let days = hours / 24
                arrayOfTime += [days]
                
                
                if days > 31 {
                    let months = days / 31
                    arrayOfTime += [months]
                    
                    
                    if months > 12 {
                        let years = months / 12
                        arrayOfTime += [years]
                        
                    }
                }
            }
        }
        
        var result = String(arrayOfTime[arrayOfTime.count - 1])
        switch arrayOfTime.count - 1 {
        case 0: result += " seconds"
        case 1: result += " minutes"
        case 2: result += " hours"
        case 3: result += " days"
        case 4: result += " months"
        case 5: result += " years"
        default: result += " fuck"
        }
        
        return "Latest activity " + result + " ago"
    }
}

