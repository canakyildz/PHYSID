//
//  User.swift
//  PHYSID
//
//  Created by Apple on 23.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

struct User {
    var name: String!
    var age: Int?
    var uid: String!
    var gender: String?
    var email: String
    var location: String
    var height: Int?
    var weight: Int?
    var bmr: Double?
    var activity: String?
    var profileImageUrl: String?
    var requiredCalories: Double?
    var dietType: String?
    var bodyGoalType: String?
    var professionType: String?
    var bio: String
    var backgroundImageUrl: String?
    var isFollowed = false
    var stats: UserRelationStats?
    var isAdmin: Bool
    var isProfessional: Bool
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }

    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.backgroundImageUrl = dictionary["backgroundImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.bmr = dictionary["bmr"] as? Double
        self.activity = dictionary["activity"] as? String ?? "Sedentary: little or no exercise"
        self.gender = dictionary["gender"] as? String ?? "Male"
        self.requiredCalories = dictionary["requiredCalories"] as? Double
        self.height = dictionary["height"] as? Int
        self.weight = dictionary["weight"] as? Int
        self.dietType = dictionary["dietType"] as? String ?? "Standard"
        self.bodyGoalType = dictionary["bodyGoalType"] as? String ?? "No goals yet"
        self.professionType = dictionary["professionType"] as? String ?? "Regular"
        self.bio = dictionary["bio"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.isAdmin = dictionary["isAdmin"] as? Bool ?? false
        self.isProfessional = dictionary["isProfessional"] as? Bool ?? false
        
    }
    
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
