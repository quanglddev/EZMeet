//
//  ResultTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import UIKit
import Pulsator
import MapKit
import Alamofire
import SwiftyJSON
import SDWebImage
import FaceAware
import Armchair
import PopupDialog
import SCLAlertView

class ResultTVC: UITableViewController {
    //MARK: Properties
    var room: Room?
    var arrayOfLocations = [Location]()
    let basePath = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let radius = "2000" //m
    let api_key = "API_KEY_WITH_PLACES_AND_MAP_SDK_ENABLED" //CHANGE CHANGE CHANGE THIS CHANGE
    var featuredPlaces = [Place]()
    
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    var dlat = 0.0
    var dlng = 0.0
    
    //MARK: Outlets
    @IBOutlet weak var pulsatorView: UIView!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblName: UITextView!
    @IBOutlet weak var lblSwiper: UILabel!
    @IBOutlet weak var placeCarousel: iCarousel!
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Everytime user uses 'get direction' or 'call' features, ask for rating
        //Armchair.userDidSignificantEvent(true)
        tableView.deselectRow(at: indexPath, animated: false)
        print(featuredPlaces[currentIndex].formatted_phone_number)
        
        switch indexPath.row {
        case 2:
            if lblAddress.text != "Address" {
                if indexPath.section == 0 && indexPath.row == 2 {
                    //Open Google maps
                    if !(UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=\(user.homeLocation.lat),\(user.homeLocation.lng)&daddr=\(dlat),\(dlng)&directionsmode=driving")!, options: [:], completionHandler: nil)
                    } else {
                        print("Can't use comgooglemaps://");
                        UIApplication.shared.open(URL(string:"http://maps.apple.com/?saddr=\(user.homeLocation.lat),\(user.homeLocation.lng)&daddr=\(dlat),\(dlng)")!)
                    }
                }
            }
        case 3:
            let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(featuredPlaces[currentIndex].place_id)&key=API_KEY_WITH_PLACES_AND_MAP_SDK_ENABLED"
            print(url)
            AF.request(URL(string: url)!)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        if let formatted_phone_number = json["result"]["formatted_phone_number"].string {
                            self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: formatted_phone_number)
                        }
                        else {
                            self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: "NO NUMBER FOUND")
                        }
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
//                    guard (response.error != nil) else {
//                        print("Error while fetching: \(String(describing: response.error!))")
//                        return
//                    }
//                    let responseJSON = SwiftyJSON.JSON(data: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//
//                    if let formatted_phone_number = responseJSON["result"]["formatted_phone_number"].string {
//                        self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: formatted_phone_number)
//                    }
//                    else {
//                        self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: "NO NUMBER FOUND")
//                    }
                }
//            Alamofire.request(URL(string: url)!)
//                .validate(contentType: ["application/json"])
//                .responseJSON { response in
//                    guard response.result.isSuccess else {
//                        print("Error while fetching: \(String(describing: response.result.error!))")
//                        return
//                    }
//
//                    let responseJSON = SwiftyJSON.JSON(data: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//
//                    if let formatted_phone_number = responseJSON["result"]["formatted_phone_number"].string {
//                        self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: formatted_phone_number)
//                    }
//                    else {
//                        self.popupConfirmCall(name: self.featuredPlaces[self.currentIndex].name, number: "NO NUMBER FOUND")
//                    }
//            }

        default:
            print()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeCarousel.dataSource = self
        placeCarousel.delegate = self
        placeCarousel.isUserInteractionEnabled = false
        
        placeCarousel.type = .cylinder
        
        //Some cool effect while finding
        let pulsator = Pulsator()
        pulsator.numPulse = 3
        pulsator.radius = 240.0
        pulsator.backgroundColor = UIColor.red.cgColor
        //pulsator.frame = CGRect(x: 0, y: 0, width: pulsatorView.frame.width, height: pulsatorView.frame.height)
        
        pulsatorView.layer.addSublayer(pulsator)
        pulsator.start()
        
        // Set up views to get voters location.
        if let room = room {
            for voter in room.voters! {
                arrayOfLocations += [voter.homeLocation]
            }
            
            //Caculate to get best point based on array of locations
            findBestCoordinate(with: arrayOfLocations)
        }
        
        updateView()
    }
    
    var bestPointLat: Double = 0.0
    var bestPointLng: Double = 0.0
    func findBestCoordinate(with locations: [Location]) {
        if locations.count == 2 {
            //Find middle point
            self.bestPointLat = (locations[0].lat + locations[1].lat) / 2
            self.bestPointLng = (locations[0].lng + locations[1].lng) / 2
            print(locations[0].lat)
            print(locations[1].lat)
            print(locations[0].lng)
            print(locations[1].lng)

        }
        else if locations.count >= 3 {
            //Find the center
            var points = [Vector]()
            
            for location in locations {
                points.append(Vector([location.lat, location.lng]))
            }
            
            let kmm = KMeans<Character>(labels: ["A"])
            kmm.trainCenters(points, convergeDistance: 0.01)
            
            for (label, centroid) in zip(kmm.labels, kmm.centroids) {
                print("\(label): \(centroid)")
                self.bestPointLat = centroid.data[0]
                self.bestPointLng = centroid.data[1]
            }
        }
        
        getNearbyLocation(withType: (room?.type)!, latitude: self.bestPointLat, longitude: self.bestPointLng) { (bestPlaces: [Place]) in
            
            self.featuredPlaces = bestPlaces
            DispatchQueue.main.async {
                self.placeCarousel.reloadData()
                
                guard let bestPlace = self.featuredPlaces[safe: 0] else {
                    return
                }
                self.lblName.text = "\(bestPlace.name) - \(self.getDistance(place: bestPlace)) meters"
                self.lblAddress.text = bestPlace.vicinity
                
                self.room?.meetLocation.inString = bestPlace.name
                self.room?.meetLocation.lat = bestPlace.lat
                self.room?.meetLocation.lng = bestPlace.lng
                
                self.dlat = bestPlace.lat
                self.dlng = bestPlace.lng
            }
            
            //Get data (images and string)
            
            //let featuredImageOfPlaceView = UIImageView(frame: CGRect(x: 0, y: 64, width: self.pulsatorView.frame.width, height: self.pulsatorView.frame.width - 64))
            let api_key = "API_KEY_WITH_PLACES_AND_MAP_SDK_ENABLED" //CHANGE CHANGE CHANGE THIS CHANGE
            
//            //Get array of images
//            for bestPlace in bestPlaces {
//                self.linkfeaturedImagesOfPlaces += [bestPlace.photo_reference]
//
//
//                featuredImageOfPlaceView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=900&photoreference=\(bestPlace.photo_reference)&rankby=distance&key=\(api_key)")!)
//                featuredImageOfPlaceView.focusOnFaces = true
//                featuredImageOfPlaceView.contentMode = .scaleAspectFill
//                self.pulsatorView.addSubview(featuredImageOfPlaceView)
//
//                //Update labels
//
//                self.lblName.text = "\(bestPlace.name) - \(self.getDistance(place: bestPlace)) meters"
//                self.lblAddress.text = bestPlace.vicinity
//
//                self.room?.meetLocation.inString = bestPlace.name
//                self.room?.meetLocation.lat = bestPlace.lat
//                self.room?.meetLocation.lng = bestPlace.lng
//
//                self.dlat = bestPlace.lat
//                self.dlng = bestPlace.lng
//            }
        }
    }
    
    
    
    func getDistance(place: Place) -> Int {
        let location = CLLocation(latitude: place.lat, longitude: place.lng)
        
        let distanceInMeters = location.distance(from: CLLocation(latitude: user.homeLocation.lat, longitude: user.homeLocation.lng))
        
        return Int(floor(distanceInMeters))
    }
    
    
    func getNearbyLocation(withType type: String, latitude: Double, longitude: Double, completion: @escaping ([Place]) -> ()) {
        let url = basePath + "location=\(latitude),\(longitude)" + "&radius=\(radius)&keyword=\(type.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: ","))&key=\(api_key)"
        print(latitude)
        print(longitude)
        print(url)
        
        AF.request(URL(string: url)!)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    debugPrint(json)
                    
                    let rows = json["results"].count
                    
                    var tempPlaces = [Place]()
                    for i in 0...rows {
                        if let eachPlace = try? Place(json: json["results"][i]) {
                            tempPlaces += [eachPlace]
                            /*
                            //Only get one
                            break*/
                            //now get 7
                            
                        }
                        if tempPlaces.count == 7 { break }
                    }
                    
                    completion(tempPlaces)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
//                guard (response.error != nil) else {
//                    print("Error while fetching: \(String(describing: response.error!))")
//                    return
//                }
//
//                //saveJSONFile(data: response.data! as NSData)
//
//                let responseJSON = SwiftyJSON.JSON(data: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//
//                let rows = responseJSON["results"].count
//
//                var tempPlaces = [Place]()
//                for i in 0...rows {
//                    if let eachPlace = try? Place(json: responseJSON["results"][i]) {
//                        tempPlaces += [eachPlace]
//                        /*
//                        //Only get one
//                        break*/
//                        //now get 7
//
//                    }
//                    if tempPlaces.count == 7 { break }
//                }
//
//                completion(tempPlaces)
        }
    }
    
    override func viewWillLayoutSubviews() {
        pulsatorView.frame.size = CGSize(width: pulsatorView.frame.width, height: pulsatorView.frame.width)
    }
    
    var currentIndex = 0
    @IBAction func scrollLeft(_ sender: UIBarButtonItem) {
        currentIndex -= 1
        if currentIndex == -1 {
            currentIndex = featuredPlaces.count - 1
        }
        self.placeCarousel.scrollToItem(at: currentIndex, animated: true)
        
        let bestPlace = self.featuredPlaces[self.currentIndex]
        self.lblName.text = "\(bestPlace.name) - \(self.getDistance(place: bestPlace)) meters"
        self.lblAddress.text = bestPlace.vicinity
        
        self.room?.meetLocation.inString = bestPlace.name
        self.room?.meetLocation.lat = bestPlace.lat
        self.room?.meetLocation.lng = bestPlace.lng
        
        self.dlat = bestPlace.lat
        self.dlng = bestPlace.lng
        
        print(currentIndex)
    }
    
    
    @IBAction func scrollRight(_ sender: UIBarButtonItem) {
        currentIndex += 1
        if currentIndex == featuredPlaces.count {
            currentIndex = 0
        }
        self.placeCarousel.scrollToItem(at: currentIndex, animated: true)
        
        let bestPlace = self.featuredPlaces[self.currentIndex]
        self.lblName.text = "\(bestPlace.name) - \(self.getDistance(place: bestPlace)) meters"
        self.lblAddress.text = bestPlace.vicinity
        
        self.room?.meetLocation.inString = bestPlace.name
        self.room?.meetLocation.lat = bestPlace.lat
        self.room?.meetLocation.lng = bestPlace.lng
        
        self.dlat = bestPlace.lat
        self.dlng = bestPlace.lng
        
        print(currentIndex)
    }
    
    func popupConfirmCall(name: String, number: String) {
        //print(number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "(", with: ""))
        print(number)
        
        let alertView = SCLAlertView()
        alertView.addButton(number) {
            guard let number = URL(string: "telprompt://" + number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "(", with: "")) else { return }
            UIApplication.shared.open(number)
        }
        alertView.showSuccess("REDIRECTING", subTitle: "Ready to call at \(name)?")
    }
}




extension ResultTVC: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return featuredPlaces.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let api_key = "API_KEY_WITH_PLACES_AND_MAP_SDK_ENABLED" //CHANGE CHANGE CHANGE THIS CHANGE
        var itemView: UIImageView
        
        //currentIndex = index
        
        //reuse view if possible, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
        }
        else {
            itemView = UIImageView(frame: CGRect(x: 24, y: 64 + 24, width: self.pulsatorView.frame.width - 24, height: self.pulsatorView.frame.width - 52 - 24))
        }
        
        itemView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=900&photoreference=\(featuredPlaces[index].photo_reference)&rankby=distance&key=\(api_key)")!)
        
        //itemView.focusOnFaces = true
        itemView.contentMode = .scaleAspectFill
        itemView.layer.cornerRadius = 10
        itemView.setNeedsDisplay()
        itemView.clipsToBounds = true
        
        //Update labels
        /*
        DispatchQueue.main.async {
            let bestPlace = self.featuredPlaces[index]
            self.lblName.text = "\(bestPlace.name) - \(self.getDistance(place: bestPlace)) meters"
            self.lblAddress.text = bestPlace.vicinity
            
            self.room?.meetLocation.inString = bestPlace.name
            self.room?.meetLocation.lat = bestPlace.lat
            self.room?.meetLocation.lng = bestPlace.lng
            
            self.dlat = bestPlace.lat
            self.dlng = bestPlace.lng
        }*/
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
}
