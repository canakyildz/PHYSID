//
//  RecipesHeaderViewModel.swift
//  PHYSID
//
//  Created by Apple on 21.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum RecipesHeaderSections: Int, CaseIterable {
    
    case Stantard
    case Vegeterian
    case Vegan
    case Paleo
    case Keto
    
    
    var description: String {
        switch self {
            
        case .Stantard:
            return "Standard"
        case .Vegeterian:
            return "Vegeterian"
        case .Vegan:
            return "Vegan"
        case .Paleo:
            return "Paleo"
        case .Keto:
            return "Keto"
            
        }
    }
    
    var sectionImage: UIImage {
        switch self {
            
        case .Stantard:
            return #imageLiteral(resourceName: "paleocell").withRenderingMode(.alwaysOriginal)
        case .Vegeterian:
            return #imageLiteral(resourceName: "Byron_Fleet0010-600x900").withRenderingMode(.alwaysOriginal)
        case .Vegan:
            return #imageLiteral(resourceName: "(CRINKLE+TOP!)+FUDGY+FLOURLESS+BROWNIES+|+dolly+and+oatmeal").withRenderingMode(.alwaysOriginal)
        case .Paleo:
            return #imageLiteral(resourceName: "peeee").withRenderingMode(.alwaysOriginal)
        case .Keto:
            return #imageLiteral(resourceName: "Spiked-Chocolate-Coconut-Custard-Ingredients").withRenderingMode(.alwaysOriginal)
            
            
        }
    }
}

