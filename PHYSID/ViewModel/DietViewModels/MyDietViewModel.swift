//
//  MyDietViewModel.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum Meals: Int, CaseIterable {
    
    case Breakfast
    case Lunch
    case Dinner
    
    var description: String {
        switch self {
            
        case .Breakfast:
            return "Breakfast"
        case .Lunch:
            return "Lunch"
        case .Dinner:
            return "Dinner"
        }
    }
    
    var mealImage: UIImage {
        switch self {
            
        case .Breakfast:
            return #imageLiteral(resourceName: "vegan-grain-free-hot-cereal-whole30-paleo-gluten-free_1619").withRenderingMode(.alwaysOriginal)
        case .Lunch:
            return #imageLiteral(resourceName: "Byron_Fleet0010-600x900").withRenderingMode(.alwaysOriginal)
        case .Dinner:
            return #imageLiteral(resourceName: "(CRINKLE+TOP!)+FUDGY+FLOURLESS+BROWNIES+|+dolly+and+oatmeal").withRenderingMode(.alwaysOriginal)
            
        }
    }
    
}

