//
//  Location Helper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import GooglePlaces

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.coordinate.latitude)")
        print("Place attributions: \(place.coordinate.longitude)")
        dismiss(animated: true, completion: nil)
        
        userHomeLocationInString = place.formattedAddress!
        userHomeLocationLat = place.coordinate.latitude
        userHomeLocationLng = place.coordinate.longitude
        
        userDefaults.set(userHomeLocationInString, forKey: defaultsKeys.userHomeLocationInString)
        userDefaults.set(userHomeLocationLat, forKey: defaultsKeys.userHomeLocationLat)
        userDefaults.set(userHomeLocationLng, forKey: defaultsKeys.userHomeLocationLng)
        
        //Done saving all needed user info, begin uploading
        let homeLocation = Location(inString: userHomeLocationInString, lat: userHomeLocationLat, lng: userHomeLocationLng)!
        user = Voter(avaURL: userDefaults.string(forKey: defaultsKeys.userAvaURL), name: userName, homeLocation: homeLocation, email: userEmail, uid: userUid)
        createUserProfile()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
