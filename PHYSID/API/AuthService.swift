//
//  AuthService.swift
//  PHYSID
//
//  Created by Apple on 23.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    
    let email: String
    let password: String
    let fullname: String
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        
        Auth.auth().signIn(withEmail: email , password: password, completion: completion)
        
        
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
            if let error = error {
                print("Error creating user \(error.localizedDescription) ")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let data = ["email" : credentials.email,
                        "fullname": credentials.fullname,
                        "uid" : uid,
                        "age" : 18] as [String: Any] //it has to cast the dictionary as String: Any because it has multiple data types like string integers here
            
            REF_USERS.child(uid).updateChildValues(data, withCompletionBlock: completion)
        }
    }
    
    
}

