//
//  ThirdRegistrationController.swift
//  PHYSID
//
//  Created by Apple on 24.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown
import Firebase

class ThirdRegistrationController: UIViewController {
    
    // MARK: - Properties
    
    
    private var user: User
    weak var delegate: AuthenticationCompletionDelegate?
    
    var bmr: Double = 0
    var userIsMale: Bool {
        return user.gender == "Male"
    }
    var rcalories: Double = 0
    
    private lazy var secondView: UIView = {
        let vv = UIView()
        let iv = UIImageView(image: #imageLiteral(resourceName: "Byron_Fleet0010-600x900"))
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        iv.addSubview(effect)
        effect.anchor(top: iv.topAnchor, left: iv.leftAnchor, bottom: iv.bottomAnchor, right: iv.rightAnchor, paddingRight: 40)
        UIView.animate(withDuration: 1.4, delay: 0, options: .curveEaseOut, animations: {
            effect.frame.origin.x = +400
        }) { (_) in
        }
        iv.contentMode = .scaleAspectFill
        vv.addSubview(iv)
        iv.fillSuperview()
        return vv
    }()
    
    private let letUsKnowMoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "One more \nstep to go "
        label.alpha = 0
        return label
    }()
    
    private let ageMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["14", "15", "16", "17", "18", "19", "20", "21","22", "23","24", "25", "26", "27", "28", "29", "30","31","32", "33","34", "35", "36", "37", "38", "39","41","41","42", "43","44", "45","46", "47", "48", "49","50","51","52","53","54", "55","56", "57", "58", "59","60","61","62"]
        menu.direction = .bottom
        return menu
    }()
    
    private let activityMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Sedentary: little or no exercise", "Light: exercise 1-3 times/week", "Moderate: exercise 4-5 times/week", "Active: daily exercise or intense exercise 3-4 times/week", "Very Active: intense exercise 6-7 times/week"]
        menu.direction = .bottom
        return menu
    }()
    
    private let genderMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Male", "Female"]
        menu.direction = .bottom
        return menu
    }()
    
    private let ageButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your Age?", framerTitle: "-", type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showAgeDrop), for: .touchUpInside)
        return button
    }()
    
    private let activityButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "How is your physical activity?", framerTitle: "-" , type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showActivityDrop), for: .touchUpInside)
        return button
    }()
    
    private let genderButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What's your gender?", framerTitle: "-" , type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showGenderDrop), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: AuthButton = {
        let button = AuthButton(title: "Save information", type: .system, color: .white, backGroundColor: .black)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleSaveInfo), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        view.addSubview(secondView)
        secondView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        
        view.addSubview(letUsKnowMoreLabel)
        letUsKnowMoreLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 85, paddingLeft: 37)
        
        UIView.animate(withDuration: 1.2) {
            self.letUsKnowMoreLabel.frame.origin.y = +100
            self.letUsKnowMoreLabel.alpha = 1
        }
        
        ageMenu.anchorView = ageButton
        activityMenu.anchorView = activityButton
        genderMenu.anchorView = genderButton
        
        let stack = UIStackView(arrangedSubviews: [ageButton,activityButton, genderButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: letUsKnowMoreLabel.bottomAnchor, left: letUsKnowMoreLabel.leftAnchor, right: secondView.rightAnchor, paddingTop: 60, paddingRight: 60)
        
        view.addSubview(saveButton)
        saveButton.centerX(inView: stack)
        saveButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 30,paddingBottom: 20, width: 200, height: 50)
        
        
    }
    
    // MARK: - Selectors
    
    @objc func handleSaveInfo() {
        guard let activity = activityButton.titleLabel?.text else { return }
        guard let gender = genderButton.titleLabel?.text else { return }
        guard let age = ageButton.titleLabel?.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.user.uid = currentUid
        self.user.activity = activity
        self.user.gender = gender
        self.user.age = Int(age) ?? 15

        // BMR
        let h = Double(self.user.height ?? 0)
        let w = Double(self.user.weight ?? 0)
        let a = Double(self.user.age ?? 0)
        let bmrW = userIsMale ? w * 13.397 : w * 9.247
        let bmrH = userIsMale ? h * 4.799 : h * 3.098
        let bmrA = userIsMale ? a * 5.677 : a * 4.330
        let bmrRandom = userIsMale ? 88.362 : 447.593
        
        let bmrResult = bmrW + bmrH - bmrA + bmrRandom
        
        self.user.bmr = bmrResult
        
        if activity == "Sedentary: little or no exercise" {
            self.bmr = bmrResult * 1.15
        } else if activity == "Light: exercise 1-3 times/week" {
            self.bmr = bmrResult * 1.32
        } else if activity == "Moderate: exercise 4-5 times/week" {
            self.bmr = bmrResult * 1.41
        } else if activity == "Active: daily exercise or intense exercise 3-4 times/week" {
            self.bmr = bmrResult * 1.49
        } else if activity == "Very Active: intense exercise 6-7 times/week" {
            self.bmr = bmrResult * 1.66
        }
        
        let bodyGoal = self.user.bodyGoalType
        
        if bodyGoal == "Thinner look" {
            self.bmr -= self.bmr / 5
        } else if bodyGoal == "Gaining weight" {
            self.bmr += self.bmr / 5
        } else if bodyGoal == "Building Muscle" {
            self.bmr += self.bmr / 5
        } else if bodyGoal == "Lean bulking" {
            self.bmr += self.bmr / 5
        } else if bodyGoal == "Losing fat" {
            self.bmr -= self.bmr / 5
        }
        

        self.user.requiredCalories = self.bmr
        
        Service.saveUserData(user: user) { (err, ref) in
            self.dismiss(animated: true) {
                Service.fetchUser(withUid: currentUid) { (user) in
                    self.user = user
                    self.delegate?.configureViewsEarly()
                }
            }
        }
        
    }
    
    @objc func showGenderDrop() {
        genderMenu.show()
        genderMenu.selectionAction = { index, item  in
            self.genderButton.setTitle("\(self.genderMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func showActivityDrop() {
        activityMenu.show()
        activityMenu.selectionAction = { index, item  in
            self.activityButton.setTitle("\(self.activityMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    
    @objc func showAgeDrop() {
        ageMenu.show()
        ageMenu.selectionAction = { index, item  in
            self.ageButton.setTitle("\(self.ageMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    // MARK: - Helpers
    
}
