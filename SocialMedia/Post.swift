//
//  Post.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 05.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postID: String!
    private var _postRef: DatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    
    
    var postID: String {
        return _postID
    }
    
    
    
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    
    init(postID: String, postData: Dictionary <String, Any>) {
        self._postID = postID
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
       
        _postRef = DataService.ds.REF_POSTS.child(postID)
    }
    
    
    
    func addJustLike(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }

}
