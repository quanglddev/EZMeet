//
//  NewMeetingTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import PopupDialog
import Firebase
import os.log
import KMPlaceholderTextView

class NewMeetingTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var newRoom: Room?
    var uuidRoom = ""
    
    //MARK: Outlets
    @IBOutlet weak var btnCreateOutlet: UIBarButtonItem!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNote: KMPlaceholderTextView!
    @IBOutlet weak var swOutlet: UISwitch!
    @IBOutlet weak var btnCancelOutlet: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        uuidRoom = UUID().uuidString
        
        lblNote.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkBtnEnability()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkBtnEnability()
    }
    
    @IBAction func swHidden(_ sender: UISwitch) {
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //Create room
    @IBAction func btnCreate(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        ref.child("rooms").child(uuidRoom).child("admin").setValue(user.uid)
        ref.child("rooms").child(uuidRoom).child("isPrivate").setValue(swOutlet.isOn)
        ref.child("rooms").child(uuidRoom).child("meetLocation").child("inString").setValue("nil")
        ref.child("rooms").child(uuidRoom).child("meetLocation").child("lat").setValue(0.0)
        ref.child("rooms").child(uuidRoom).child("meetLocation").child("lng").setValue(0.0)
        ref.child("rooms").child(uuidRoom).child("notes").setValue(lblNote.text)
        ref.child("rooms").child(uuidRoom).child("title").setValue(tfTitle.text)
        ref.child("rooms").child(uuidRoom).child("type").setValue(lblType.text)
        ref.child("rooms").child(uuidRoom).child("voters").child(user.uid).setValue(user.name)
        
        ref.child("rooms").child(uuidRoom).child("lastActivity").setValue(Int(Date().timeIntervalSince1970))
        
        //Add to personal room too
        ref.child("users").child(user.uid).child("rooms").child(uuidRoom).setValue(tfTitle.text)
        
        shouldRefresh = true
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            //Show popup ask type
            // Prepare the popup assets
            let title = "PLACE TYPE SELECTION"
            let message = "Please specify which kind of place you want to meet. This help us find the meeting place much easier."
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message)
            
            // Create buttons
            let btnRestaurant = DefaultButton(title: "🍗 RESTAURANT 🍸") {
                self.lblType.text = "Restaurant"
                self.checkBtnEnability()
            }
            let btnCoffee = DefaultButton(title: "☕️ COFFEE ☕️") {
                self.lblType.text = "Coffee"
                self.checkBtnEnability()
            }
            let btCinema = DefaultButton(title: "🎥 CINEMA 🍿") {
                self.lblType.text = "Cinema"
                self.checkBtnEnability()
            }
            let btnPark = DefaultButton(title: "⚽️ PARK ⚾️") {
                self.lblType.text = "Park"
                self.checkBtnEnability()
            }
            let btnLibrary = DefaultButton(title: "📚 LIBRARY 📕") {
                self.lblType.text = "Library"
                self.checkBtnEnability()
            }
            let btnCancel = CancelButton(title: "💧 JUST NOT IN THE RIVER 💦") {
                self.lblType.text = "Select Types"
                self.checkBtnEnability()
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([btnRestaurant, btnCoffee, btCinema, btnPark, btnLibrary, btnCancel])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    func checkBtnEnability() {
        if !(tfTitle.text?.isEmpty)! && !(tfTitle.text?.isEmpty)! && lblType.text != "Select Types" {
            btnCreateOutlet.isEnabled = true
        }
        else {
            btnCreateOutlet.isEnabled = false
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    /*
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === btnCreateOutlet else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let admin = Voter(avatar: user.avatar, name: user.name, homeLocation: user.homeLocation, email: user.email, uid: user.uid)!
        let tempMeetLocation = Location(inString: "nil", lat: 0.0, lng: 0.0)!

        newRoom = Room(title: tfTitle.text!, admin: admin, voters: [admin], meetLocation: tempMeetLocation, notes: lblNote.text, type: lblType.text!, isPrivate: swOutlet.isOn, uuid: uuidRoom)
    }*/
}

// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
