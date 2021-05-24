//
//  Post.swift
//  PHYSID
//
//  Created by Apple on 12.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

struct Post {
    var caption: String
    var title: String
    var postImageUrl: String?
    var postID: String
    var ownerUid: String
    var timestamp: Date!
    var user: User
    var likes: Int
    var didLike = false
    var comments: Int
    var isSay = false
    //    var isSaved
    
    init(user: User, postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.isSay = dictionary["isSay"] as? Bool ?? false
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
    }
}
