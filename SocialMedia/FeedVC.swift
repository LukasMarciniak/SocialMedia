//
//  FeedVC.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 04.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func outbtn(_ sender: Any) {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
    }
   
}
