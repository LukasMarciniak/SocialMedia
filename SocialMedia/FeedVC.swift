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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var FeedTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FeedTable.dataSource = self
        FeedTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return FeedTable.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    

    @IBAction func outbtn(_ sender: Any) {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
    }
   
}
