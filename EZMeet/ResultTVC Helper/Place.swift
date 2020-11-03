//
//  Place.swift
//  EZMeet
//
//  Created by QUANG on 8/1/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Place {
    let name: String
    let icon: String
    let rating: Double
    let lat: Double
    let lng: Double
    let vicinity: String
    let featureImages: String
    let place_id: String
    let photo_reference: String
    let formatted_phone_number: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: SwiftyJSON.JSON) throws {
        guard let name = json["name"].string else {
            throw SerializationError.missing("Missing name")
        }
        
        guard let icon = json["icon"].string else {
            throw SerializationError.missing("Missing icon")
        }
        
        guard let rating = json["rating"].double else {
            throw SerializationError.missing("Missing rating")
        }
        
        guard let lat = json["geometry"]["location"]["lat"].double else {
            throw SerializationError.missing("Missing lat")
        }
        
        guard let lng = json["geometry"]["location"]["lng"].double else {
            throw SerializationError.missing("Missing lng")
        }
        
        guard let vicinity = json["vicinity"].string else {
            throw SerializationError.missing("Missing vicinity")
        }
        
        guard let featureImages = json["photos"][0]["html_attributions"][0].string else {
            throw SerializationError.missing("Missing featureImages")
        }
        
        guard let place_id = json["place_id"].string else {
            throw SerializationError.missing("Missing place_id")
        }
        
        guard let photo_reference = json["photos"][0]["photo_reference"].string else {
            throw SerializationError.missing("Missing photo_reference")
        }
        
        let formatted_phone_number = json["formatted_phone_number"].stringValue
        
        self.name = name
        self.icon = icon
        self.rating = rating
        self.lat = lat
        self.lng = lng
        self.vicinity = vicinity
        self.featureImages = featureImages
        self.place_id = place_id
        self.photo_reference = photo_reference
        self.formatted_phone_number = formatted_phone_number
    }
}

