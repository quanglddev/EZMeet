//
//  DetailTVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import MessageUI
import SCLAlertView
import Alamofire
import SwiftyJSON

class DetailTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var lblIsHidden: UITextField!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNote: UITextView!
    @IBOutlet weak var lblNumOfVoters: UILabel!
    @IBOutlet weak var btnFindOutlet: UIButton!
    
    
    //MARK: Properties
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    var room: Room?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        if (room?.voters?.count)! > 1 {
            btnFindOutlet.isEnabled = true
        }
        else {
            btnFindOutlet.setTitle("Find more", for: .normal)
            btnFindOutlet.isHidden = true
        }
        
        btnFindOutlet.layer.cornerRadius = 20
        
        // Set up views if showing an existing Room.
        if let room = room {
            
            lblTitle.text = room.title
            lblAdmin.text = "by \(room.admin.name)"
            if room.isPrivate {
                lblIsHidden.text = "HIDDEN"
            }
            else {
                lblIsHidden.text = "OPEN"
            }
            lblType.text = room.type
            if let note = room.notes {
                lblNote.text = note
            }
            else {
                lblNote.text = ""
            }
            lblNumOfVoters.text = "\(room.voters?.count ?? 0) Participated"
        }
    }
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && indexPath.section == 0 {
            return 99.5
        }
        return 56
    }*/
    
    @IBAction func btnFind(_ sender: UIButton) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "CaculationVC") as! UINavigationController
        present(controller, animated: true, completion: nil)*/
    }
    
    
    @IBAction func btnContact(_ sender: UIBarButtonItem) {
        if !MFMailComposeViewController.canSendMail() {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            }
            alertView.showWarning("NO EMAIL IDENTIFIED", subTitle: "PLEASE SET UP YOUR EMAIL IN APPLE MAIL APP", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction))
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([room?.admin.email ?? "quangscorpio@gmail.com"])
        composeVC.setSubject("QUESTION ABOUT \(room?.title ?? "ROOM")")
        composeVC.setMessageBody("Hello World!", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)

    }
    
    @IBAction func btnInvite(_ sender: UIBarButtonItem) {
        //let url = "http://deeplink.me/ezmeet.wordpress.com/invite/\(room?.uuid ?? "FAILED")"
        
        guard let roomUUID = room?.uuid else { return }
        let url = "EZMeet://invite/\(roomUUID)"
        
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        /*
        //Shorten the link to look professional
        let parameters = ["longUrl": "\(url)"]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        Alamofire.request("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyA87ft_Z2qftuRqrBXOIDfenuDkp2KfCNY", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard let data = response.data else { return }
            let json = JSON(data: data)
            guard let shortURL = json["id"].string else {
                print("fail")
                return
            }
            
            
            let activityController = UIActivityViewController(activityItems: [shortURL], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }*/
    }
    
    @IBAction func btnReturn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "Caculation":
            guard let caculationViewController = segue.destination as? ResultTVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            caculationViewController.room = room
        case "participationDetail":
            guard let detailTVC = segue.destination as? ParticipationDetailTVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            detailTVC.room = room
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
