//
//  PostCell.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 05.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        self.PostTxt.text = post.caption
        self.LikeLbl.text = "\(post.likes)"
    }

}
