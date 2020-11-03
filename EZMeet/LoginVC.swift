//
//  LoginVC.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftyJSON
import GoogleSignIn

class LoginVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginButton()
    }
    
}
