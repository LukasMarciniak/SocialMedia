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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FeedTable.dataSource = self
        FeedTable.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("snap: \(snap)")
                    if let postDict = snap.value as? Dictionary <String, AnyObject> {
                        let key = snap.key
                        let post = Post(postID: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.FeedTable.reloadData()
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let post = posts[indexPath.row]
        
        if let cell = FeedTable.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        }else {
            return PostCell()
        }
    }
    

    @IBAction func outbtn(_ sender: Any) {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
    }
   
}
