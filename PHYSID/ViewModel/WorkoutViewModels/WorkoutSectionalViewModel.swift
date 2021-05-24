//
//  WorkoutSectionalViewModel.swift
//  PHYSID
//
//  Created by Apple on 3.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum WorkoutSectionalSections: Int, CaseIterable {
    
    case MyProgram
    case WholeWorkoutContents
    case ConditionalWorkouts
    case SpecificBodyParts
    case CrossFitContents
    case MyFavorites
    case AllContents
    
    var description: String {
        switch self {
            
        case .MyProgram:
            return "My Program"
        case .WholeWorkoutContents:
            return "Whole Workouts"
        case .SpecificBodyParts:
            return "One Move"
        case .CrossFitContents:
            return "CrossFit"
        case .ConditionalWorkouts:
            return "Condition Based"
        case .MyFavorites:
            return "My Favorites"
        case .AllContents:
            return "All Contents"
        }
    }
    
    
    var information: String {
        switch self {
            
        case .MyProgram:
            return "By our professionals, specially and carefully designed for you. You can always change things inside."
        case .WholeWorkoutContents:
            return "Whole workouts are here to give you that pump the muscles and get the job done. Videos are over 5 minutes goes up to 1 hour."
        case .SpecificBodyParts:
            return "If you just want to get the -one move- treatment, effiency based mind-muscle connective contents are here."
        case .CrossFitContents:
            return "Someone said CrossFit? Just come on in"
        case .ConditionalWorkouts:
            return "If you ain't dripping, you tripping. We promise you the workout that brings sweat and blood"
        case .MyFavorites:
            return "Approved by you! :)"
        case .AllContents:
            return "Every content. You can filter through them according to body parts and such patterns."
        }
    }
    
    
    var sectionImage: UIImage {
        switch self {
            
        case .MyProgram:
            return #imageLiteral(resourceName: "116350782_3140943039346011_4347069755778829387_n").withRenderingMode(.alwaysOriginal)
        case .WholeWorkoutContents:
            return #imageLiteral(resourceName: "Men's GYM Fitness Clothing simple").withRenderingMode(.alwaysOriginal)
        case .SpecificBodyParts:
            return #imageLiteral(resourceName: "Women's UA Wordmark Strappy Sportlette").withRenderingMode(.alwaysOriginal)
        case .CrossFitContents:
            return #imageLiteral(resourceName: "Snorri Björnsson - SARA SIGMUNDSDOTTIR").withRenderingMode(.alwaysOriginal)
        case .ConditionalWorkouts:
            return #imageLiteral(resourceName: "101674876_171431994403571_7801526117140394783_n").withRenderingMode(.alwaysOriginal)
        case .MyFavorites:
            return #imageLiteral(resourceName: "92340724_2597223973854455_2082601901323086880_n").withRenderingMode(.alwaysOriginal)
        case .AllContents:
            return #imageLiteral(resourceName: "90087799_1085110848513501_5092666401299502603_n").withRenderingMode(.alwaysOriginal)
            
        }
    }
    
}
