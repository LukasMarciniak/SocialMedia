//
//  PostCell.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 05.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var ProfileImg: UIImageView!
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var EmptyImg: UIImageView!
    @IBOutlet weak var PostImg: UIImageView!
    @IBOutlet weak var PostTxt: UITextView!
    @IBOutlet weak var constatnsLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!

    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
      
        self.post = post
        self.PostTxt.text = post.caption
        self.LikeLbl.text = "\(post.likes)"
        
        if img != nil {
            self.PostImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("Unable to download")
                } else {
                print("Img downloaded")
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                        self.PostImg.image = img
                        FeedVC.imageCache.object(forKey: post.imageURL as NSString)
                        
                        }
                    }
                }
                
                })
        }
    }

}
