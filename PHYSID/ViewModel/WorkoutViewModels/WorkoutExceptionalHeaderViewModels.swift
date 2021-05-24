//
//  WorkoutExceptionalHeaders.swift
//  PHYSID
//
//  Created by Apple on 8.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum WorkoutExceptionalHeaderViewModels: Int, CaseIterable {
    
    case firstView
    case secondaryView
    case thirdView
    
    var firstInformation: String {
        switch self {
            
        case .firstView:
            return "Our -one move- treatments are way more than being about efficiency. We wanted to break barries but don't go too extreme where we break the purity and simplicity."
        case .secondaryView:
            return "We look towards to work with professionals! contact@physid.com"
        case .thirdView:
            return "Live group workout sessions are here soon! "
        
        }
    }
    
    
    var firstImages: UIImage {
        switch self {
            
        case .firstView:
            return #imageLiteral(resourceName: "Women's UA Wordmark Strappy Sportlette").withRenderingMode(.alwaysOriginal)
        case .secondaryView:
            return #imageLiteral(resourceName: "116350782_3140943039346011_4347069755778829387_n").withRenderingMode(.alwaysOriginal)
        case .thirdView:
            return #imageLiteral(resourceName: "Snorri Björnsson - SARA SIGMUNDSDOTTIR").withRenderingMode(.alwaysOriginal)
            
        }
    }
    
    
    var secondaryInformation: String {
        switch self {
            
        case .firstView:
            return "Condition based contents are way more than being about efficiency. We wanted to break barries but don't go too extreme where we break the purity and simplicity."
        case .secondaryView:
            return "Find out more about foods, their recipes and personalized diets for you!"
        case .thirdView:
            return "Live group workout sessions are here soon! "
        
        }
    }
    
    
    var secondaryImages: UIImage {
        switch self {
            
        case .firstView:
            return #imageLiteral(resourceName: "Men's GYM Fitness Clothing simple").withRenderingMode(.alwaysOriginal)
        case .secondaryView:
            return #imageLiteral(resourceName: "Byron_Fleet0010-600x900").withRenderingMode(.alwaysOriginal).withHorizontallyFlippedOrientation()
        case .thirdView:
            return #imageLiteral(resourceName: "Women's UA Wordmark Strappy Sportlette").withRenderingMode(.alwaysOriginal)
            
        }
    }
}

