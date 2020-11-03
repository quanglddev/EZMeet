//
//  GetUserLocationHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import PopupDialog
import GooglePlaces

extension ViewController {
    func checkAskForLocation() {
        //Check if user set location
        if let location = userDefaults.object(forKey: defaultsKeys.userHomeLocationInString) {
            print(location)
        }
        else {
            // Prepare the popup assets
            let title = "WELCOME TO EZ🍿MEET"
            let message = "Please specify your address. We promise to keep the information privately."
            let image = UIImage(named: "popup")
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, image: image)
            
            // Create buttons
            let buttonOne = CancelButton(title: "CANCEL") {
                print("You canceled the car dialog.")
            }
            
            let buttonTwo = DefaultButton(title: "SET LOCATION") {
                print("Good choice")
                //Choose location
                self.openNewViewToChooseLocation()
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    
    func openNewViewToChooseLocation() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}
