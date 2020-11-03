//
//  FBLoginHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftyJSON
import GoogleSignIn

extension LoginVC: LoginButtonDelegate {
    func setupLoginButton() {
        setupFacebook()
        setupGoogle()
    }
    
    func setupFacebook() {
        let fbLoginButton = FBLoginButton(frame: CGRect(x: 18, y: view.frame.height / 2 + 25 + 50, width: view.frame.width - 36, height: 50))
        imageView.addSubview(fbLoginButton)
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["email", "public_profile"]
    }
    
    func setupGoogle() {
        let ggLoginButton = GIDSignInButton(frame: CGRect(x: 18 , y: view.frame.height / 2 + 25 + 50 + 66, width: view.frame.width - 36, height: 50))
        imageView.addSubview(ggLoginButton)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error ?? "Error has no content")
            return
        }
        print("Successfully logged into Facebook")
        
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, err) in
            if let err = err {
                print("Something's wrong: ", err)
                return
            }
            print("Sucessfully log firebase through facebook: ", user?.user.uid ?? "")
            userUid = user?.user.uid ?? ""
            userDefaults.set(userUid, forKey: defaultsKeys.userUid)
            print(user?.user.displayName ?? "")
            userName = user?.user.displayName ?? ""
            print(user?.user.email ?? "")
            userEmail = user?.user.email ?? ""
            print(user?.user.photoURL ?? "")
            userAvaURL = user?.user.photoURL?.absoluteString ?? ""
            
            Universial.saveUserInfo()
            self.moveToMainVC()
        }
    }
    
    func moveToMainVC() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! UINavigationController
        controller.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
        }
//        present(controller, animated: true, completion: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)

    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}
