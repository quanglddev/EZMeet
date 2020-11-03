//
//  GoogleSignInHelper.swift
//  EZMeet
//
//  Created by Quang Luong on 11/2/20.
//

import GoogleSignIn
import Firebase

extension AppDelegate: GIDSignInDelegate {
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to lig into Google: ", err)
            return
        }
        print("Successfully logged into Google")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        print(user.profile.name ?? "no name")
        print(user.profile.givenName + " " + user.profile.familyName)
        print(user.profile.email ?? "no email")
        
        userName = user.profile.givenName + " " + user.profile.familyName
        userEmail = user.profile.email
        
        
        if user.profile.hasImage {
            print(user.profile.imageURL(withDimension: 100) ?? "no profile image")
            userAvaURL = user.profile.imageURL(withDimension: 100).absoluteString
        }
        
        moveToMainVC()
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error {
                print("Failed to log into Firebase through Google: ", err)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            print("Successfully logged into Firebase through Google: ", uid)
            userUid = uid
            userDefaults.set(userUid, forKey: defaultsKeys.userUid)
        }
        
        Universial.saveUserInfo()
    }
    
    func moveToMainVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainVC")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
