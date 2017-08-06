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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var FeedTable: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var PostTextField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache <NSString, UIImage> = NSCache()
    var imageSelected = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelected = true
            imageAdd.image = image
        } else {
            print("A void image wasn't selection")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(imageURL: String) {
        let post: Dictionary<String, AnyObject> = [
        
            "caption": PostTextField.text as AnyObject,
            "imageURL": imageURL as AnyObject,
            "likes": 0 as AnyObject
        
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        PostTextField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        FeedTable.reloadData()
    }

    @IBAction func addImgTapped(_ sender: Any) {
        present(imagePicker, animated:  true, completion: nil)
    }
    
    
    @IBAction func outbtn(_ sender: Any) {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
    }
    
    
    @IBAction func postAddTapped(_ sender: Any) {
        
        guard let caption = PostTextField.text, caption != "" else {
            print("caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("IMage must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGE.child(imgUid).putData(imageData, metadata: metadata) { (metadata, error) in
            
                if error != nil {
                    print("Unable upload")
                } else {
                    print("Uploada success")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageURL: url)
                    }
                }
                
            
            }
        }
        
    }
   
}
