//
//  AuthManager.swift
//  HB141
//
//  Created by Daniel Becker on 4/7/17.
//  Copyright © 2017 International Human Trafficking Institute. All rights reserved.
//

import Foundation
import Firebase
//import GoogleSignIn
//import FacebookCore
//import FacebookLogin

class AuthManager {
    static let shared = AuthManager()
    
    func current() -> FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    
    func loginStandard(username: String, password: String, completion : ((_ isSuccessful: Bool) -> Void)!) {
        FIRAuth.auth()?.signIn(withEmail: username, password: password) {
            (user, error) in
            if completion != nil {
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func registerStandard(username: String, password: String, completion: ((_ isSuccessful: Bool) -> Void)!) {
        FIRAuth.auth()?.createUser(withEmail: username, password: password) {
            (user, error) in
            if completion != nil {
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func updateEmail(newEmail : String) {
        FIRAuth.auth()?.currentUser?.updateEmail(newEmail, completion: nil)
    }
    
//    func loginGoogle(user: GIDGoogleUser!, completion: ((_ isSuccessful: Bool) -> Void)!) {
//        guard let authentication = user.authentication else {
//            return
//        }
//        
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//        
//        loginExternal(credential: credential, completion: completion)
//    }
//    
//    func loginFacebook(loginResult: LoginResult, completion: ((_ isSuccessful: Bool) -> Void)!) {
//        switch loginResult {
//        case .failed(_):
//            completion(false)
//        case .success(_, _, let accessToken):
//            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
//            self.loginExternal(credential: credential) {
//                (isSuccessful) -> Void in
//                completion(isSuccessful)
//                if isSuccessful {
//                    let current = self.current()
//                    if (current?.email == nil) { // new user. get email from Facebook
//                        let params = ["fields" : "email"]
//                        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
//                        graphRequest.start {
//                            (urlResponse, requestResult) in
//                            
//                            switch requestResult {
//                            case .failed(let error):
//                                print("error in graph request:", error)
//                                break
//                            case .success(let graphResponse):
//                                if let responseDictionary = graphResponse.dictionaryValue {
//                                    let email = responseDictionary["email"] as? String
//                                    
//                                    //TODO: Add check to see if previous user exists with this email, and then merge
//                                    current?.updateEmail(email!, completion: nil)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        default:
//            print("Facebook Login Result neither Success or Failure")
//        }
//
//    }
    
    func logOut(completion: ((_ isSuccessful: Bool) -> Void)!) {
        do {
//            if AccessToken.current != nil { // authenticated with Facebook
//                let loginManager = LoginManager()
//                loginManager.logOut()
//            }
            try FIRAuth.auth()?.signOut()
            completion(true)
        } catch let error as NSError {
            print("Error signing out: \(error)")
            completion(false)
        }
    }
    
    func userHasStandard() -> Bool {
        return userHasLoginType(type: "password")
    }
    
    func userHasFacebook() -> Bool {
        return userHasLoginType(type: "facebook")
    }
    
    func userHasGoogle() -> Bool {
        return userHasLoginType(type: "google")
    }
    
    private func userHasLoginType(type: String) -> Bool {
        let user = current()
        for provider in (user?.providerData)! {
            if provider.providerID.contains(type) {
                return true;
            }
        }
        return false
    }
    
    private func loginExternal(credential: FIRAuthCredential, completion: ((_ isSuccessful : Bool) -> Void)!) {
        FIRAuth.auth()?.signIn(with: credential) {
            (user, error) in
            if completion != nil {
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
}
