//
//  ViewController.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import os.log
import Floaty
import SwiftyJSON
import FBSDKLoginKit
import PopupDialog
import GooglePlaces
import Firebase
import MessageUI
import SCLAlertView
import StatefulViewController

let roomCellID = "RoomCell"

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, StatefulViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    //var refreshControl: UIRefreshControl!
    
    
    //MARK: Outlets
    @IBOutlet weak var pollTableView: UITableView!
    @IBOutlet weak var floatingBtn: Floaty!
    
    
    var rooms = [Room]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        // Load any saved tasks, otherwise load sample data.
        if !isInternetAvailable() {
            if let savedRooms = loadRooms() {
                rooms += savedRooms
            }
        }
        
        //Cool custom refresh
        //initialRefreshCapability()

        //The magical floating button
        setupFloatingButton()

        //Load what we saved
        loadUserInfo()
        
        signedInStatus(isSignedIn: true)
        
        //createMeetingRoom()
        //createUserProfile()
        
        //getJoinedRoomsFromFirebase()
        
        shouldRefresh = true
        
        self.checkIfThereIsInvitation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        //Stateful pod
        
        // Setup placeholder views
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(refresh))
        errorView = failureView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialViewState()
        
        refresh()
    }
    
    @objc func refresh() {
        self.checkAskForLocation()
        
        if (user) != nil && shouldRefresh {
            shouldRefresh = false
            
            startLoading {
                print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
            }
            
            self.getJoinedRoomsFromFirebase()
        }
        
        self.checkIfThereIsInvitation()
    }
    
    @objc func appDidBecomeActive() {
        self.checkIfThereIsInvitation()
    }
    
    deinit {
        //ref.child("users").child(user.uid).removeObserver(withHandle: _refHandle)
        if (ref != nil) {
            ref.child("users").child(user.uid).child("rooms").removeAllObservers()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController {
    
    func hasContent() -> Bool {
        return rooms.count > 0
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
