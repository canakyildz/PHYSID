//
//  Food.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

struct Food {
    
    var foodName: String
    var foodId: String
    var foodTypeViewModel: String
    var calories: Int
    var proteins: Int
    var fats: Int
    var carbs: Int
    var foodDescriptiveBio: String
    var foodProfileImageUrl: String?
    var recipeVideoUrl: String?
    var foodCategory: String
    var foodPreparationCost: String
    var foodPreparationTime: String
    
    init(foodId: String, dictionary: [String: Any]) {
        self.foodName = dictionary["foodName"] as? String ?? ""
        self.calories = dictionary["calories"] as? Int ?? 0
        self.proteins = dictionary["proteins"] as? Int ?? 0
        self.fats = dictionary["fats"] as? Int ?? 0
        self.carbs = dictionary["carbs"] as? Int ?? 0
        self.foodId = dictionary["foodId"] as? String ?? ""
        self.foodDescriptiveBio = dictionary["foodDescriptiveBio"] as? String ?? ""
        self.foodProfileImageUrl = dictionary["foodProfileImageUrl"] as? String ?? ""
        self.recipeVideoUrl = dictionary["recipeVideoUrl"] as? String ?? ""
        self.foodTypeViewModel = dictionary["foodType"] as? String ?? "Standard"
        self.foodCategory = dictionary["foodCategory"] as? String ?? "Atıştırmalık"
        self.foodPreparationCost = dictionary["foodPreparationCost"] as? String ?? "Düşük Bütçeli"
        self.foodPreparationTime = dictionary["foodPreparationTime"] as? String ?? "10 min"
    }
    
}
