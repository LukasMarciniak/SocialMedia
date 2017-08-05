//
//  SignVC.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 03.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper


class SignVC: UIViewController {
    @IBOutlet weak var emailbox: UITextField!
    @IBOutlet weak var pwdbox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func FBLog(_ sender: Any) {
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Sorry, problem with authentication!")
            } else if result?.isCancelled == true {
                print("User canceled FB authentication")
            } else {
                print("Success")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAut(credential)
            
            
            }
        
        }
    }
    
    func firebaseAut (_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: { (user, err) in
            if err != nil
            {
                print("Unable to Authenticate")
            }else {
                print("Success")
                
                if let user = user {
                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    let userData = ["provider": user.providerID]
                    self.completeSignin(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func EPbtn(_ sender: Any) {
        if let email = emailbox.text, let pwd = pwdbox.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, err) in
                if err == nil {
                    print("Email used")
                    if let user = user {
                        KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                        let userData = ["provider": user.providerID]
                        self.completeSignin(id: user.uid, userData: userData)
                    }
                }else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, err) in
                        if err != nil {
                            print("Unable")
                    
                        } else {
                            print("Success")
                            if let user = user {
                                KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                                let userData = ["provider": user.providerID]
                                self.completeSignin(id: user.uid, userData: userData)
                            }
                        }
                
                    })
                    }
        
                    })
                }
            }
    func completeSignin(id: String, userData: Dictionary <String, String>) {
        
        DataService.ds.createFireDBUser(uid: id, userData: userData)
       let keychain = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("data saved: \(keychain)")
        performSegue(withIdentifier: "goFeed", sender: nil)
    
    }
    
    }





