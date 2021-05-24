//
//  AuthViewModel.swift
//  Tinder
//
//  Created by Apple on 25.07.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var fullname: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false
    }
}
