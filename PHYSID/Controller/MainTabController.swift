//
//  HomeController.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class MainTabController : UITabBarController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
    }
    

    // MARK: - Helpers
    
    func configureViewControllers() {
        
        let feedNav = constructNavController(title: "Feed", unselectedImage: #imageLiteral(resourceName: "icons8-home-24-2"), selectedImage: #imageLiteral(resourceName: "icons8-home-24"), rootViewController: FeedController())
        
        let dietNav = constructNavController(title: "Diets", unselectedImage: #imageLiteral(resourceName: "icons8-vegetarian-food-24"), selectedImage: #imageLiteral(resourceName: "icons8-vegetarian-food-24-2"), rootViewController: DietController())
        
        let workoutNav = constructNavController(title: "Programs", unselectedImage: #imageLiteral(resourceName: "icons8-trainers-24"), selectedImage: #imageLiteral(resourceName: "icons8-trainers-24-2"), rootViewController: WorkoutSectionalController())
        
        let peopleNav = constructNavController(title: "Explore", unselectedImage: #imageLiteral(resourceName: "icons8-search-client-24-3"), selectedImage: #imageLiteral(resourceName: "icons8-search-client-24-3"), rootViewController: PeopleController())
        
        let controller = ProfileController()
        let profNav = constructNavController(title: "Profile", unselectedImage: #imageLiteral(resourceName: "icons8-person-female-24-2"), selectedImage: #imageLiteral(resourceName: "icons8-person-female-24-2"), rootViewController: controller)
        
        
        
        viewControllers = [feedNav,peopleNav,workoutNav, dietNav, profNav]
        
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
//            fetchUser()
            configureViewControllers()
        }
    }
    

    
    func constructNavController(title: String,unselectedImage: UIImage,selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: -8, left: 0, bottom: -12, right: 0)
        navController.tabBarItem.title = title
        navController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        navController.navigationBar.backgroundColor = .black
        navController.navigationBar.barStyle = .default
        navController.navigationBar.barTintColor = .black
        return navController
    }
    
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MainTabController: AuthenticationCompletionDelegate {
    func configureViewsEarly() {
        self.authenticateUserAndConfigureUI()
    }
    
    
}


