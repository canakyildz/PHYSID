//
//  ProfessionalHeaderViewModel.swift
//  PHYSID
//
//  Created by Apple on 18.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum ProfessionalTypes: Int, CaseIterable {
    
    case PersonalTrainer
    case StrengthConditioningCoach
    case SportsFitnessNutritionist
    case LifeCoach
    case PhysicalTherapist
    case AthleticTrainer
    case PerformanceTrainer
    case PhysicalEducationInstructor
    case SportsPhysician
    case SportsPsychologist
    
    
    var description: String {
        switch self {
            
        case .PersonalTrainer:
            return "Personal Trainer"
        case .StrengthConditioningCoach:
            return "Strength and Conditioning Coach"
        case .SportsFitnessNutritionist:
            return "Sports and Fitness Nutritionist"
        case .LifeCoach:
            return "Life Coach"
        case .PhysicalTherapist:
            return "Physical Therapist"
        case .AthleticTrainer:
            return "Athletic Trainer"
        case .PerformanceTrainer:
            return "Perfomance Trainer"
        case .PhysicalEducationInstructor:
            return "Physical Education Instructor"
        case .SportsPhysician:
            return "Sports Physician"
        case .SportsPsychologist:
            return "Sports Psychologist"
        }
    }
}
