//
//  FloatingBtnHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

let newMeetingVCID = "NewMeetingVC"
extension ViewController {
    func setupFloatingButton() {
        
        floatingBtn.addItem("Hang Out", icon: #imageLiteral(resourceName: "Hang out")) { (item) in
            /*
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)*/
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: newMeetingVCID) as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
}
