//
//  DataService.swift
//  SocialMedia
//
//  Created by Lukasz Marciniak on 05.08.2017.
//  Copyright © 2017 Lukasz Marciniak. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STOIRAGE_BASE = Storage.storage().reference()

class DataService  {
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    private var _REF_POST_IMAGE = STOIRAGE_BASE.child("post-picks")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USERS_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGE: StorageReference {
        return _REF_POST_IMAGE
    }
    
    func createFireDBUser (uid: String, userData: Dictionary <String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
