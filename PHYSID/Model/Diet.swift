//
//  Diet.swift
//  PHYSID
//
//  Created by Apple on 8.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

struct Diet {
    
    var ownerId: String!
    var dietId: String!
    var creationDate: Date!
    var dietType: String?
    var dietDescriptiveBio: String
    var dietDefinitiveImageUrl: String?
    var dietTitle: String
    var isFree: Bool
    var likes: Int
    var comments: Int
    var minCalories: Int
    var maxCalories: Int
    var carbsPercentage: Int
    var proteinsPercentage: Int
    var fatsPercentage: Int
    
    init(dietId: String,dictionary: [String: Any] ) {
        
        self.ownerId = dictionary["ownerId"] as? String ?? ""
        self.dietId = dictionary["dietId"] as? String ?? ""
        self.dietType = dictionary["dietType"] as? String ?? ""
        self.dietTitle = dictionary["dietTitle"] as? String ?? ""
        self.isFree = dictionary["isFree"] as? Bool ?? false
        self.dietDefinitiveImageUrl = dictionary["dietDefinitiveImageUrl"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.minCalories = dictionary["minCalories"] as? Int ?? 0
        self.maxCalories = dictionary["maxCalories"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        self.carbsPercentage = dictionary["carbsPercentage"] as? Int ?? 0
        self.proteinsPercentage = dictionary["proteinsPercentage"] as? Int ?? 0
        self.fatsPercentage = dictionary["fatsPercentage"] as? Int ?? 0
        self.dietDescriptiveBio = dictionary["dietDescriptiveBio"] as? String ?? ""

        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
}

