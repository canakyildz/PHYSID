//
//  LackInfoView.swift
//  PHYSID
//
//  Created by Apple on 25.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown
import Firebase

protocol lackDelegate: class {
    func dismissal(_ view: LackInfoView)
    func dismissalFromController(_ controller: LackInfoView)
}

class LackInfoView: UIViewController {
    
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    var isView = false
    
    private let scrollView = UIScrollView()
    var bmr: Double = 0
    var userIsMale: Bool {
        return user?.gender == "Male"
    }
    var rcalories: Double = 0
    
    weak var delegate: lackDelegate?
    
    let ImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Lack Information"
        label.textColor = .black
        label.layer.shadowOffset = CGSize(width: 0.2, height: 1)
        label.layer.shadowOpacity = 0
        label.numberOfLines = 0
        label.layer.cornerRadius = 2
        label.layer.shadowColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    let descriptiveInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't filled up some of your personal information.To be able to give you certain and the most efficient program or diet we need your body values."
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let weightMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["50", "51", "52", "53", "54", "55", "56", "57","58", "59","60", "61", "62", "63", "64", "65", "66","67","68", "69","70", "71", "72", "73", "74", "75", "76","77","78", "79", "80", "81", "82", "83", "84", "85", "86","87","88", "89","90", "91", "92", "93", "94", "95", "96","97","98", "99", "100", "101", "102", "103", "104", "105", "106","107","108", "109","110","111", "112", "113", "114", "115", "116","117","118", "119"]
        menu.direction = .bottom
        return menu
    }()
    
    private let heightMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["150", "151", "152", "153", "154", "155", "156", "157","158", "159","160", "161", "162", "163", "164", "165", "166","167","168", "169","170", "171", "172", "173", "174", "175", "176","177","178", "179", "180", "181", "182", "183", "184", "185", "186","187","188", "189","190", "191", "192", "193", "194", "195", "196","197","198", "199", "200", "201", "202", "203", "204", "205", "206","207","208", "209","210"]
        menu.direction = .bottom
        return menu
    }()
    
    private let dietTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Standard", "Vegeterian", "Vegan", "Keto", "Paleo"]
        menu.direction = .bottom
        return menu
    }()
    
    private let bodyTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Thinner look", "Gaining weight", "Building muscle", "Lean bulking" , "Losing fat", "No goals yet"]
        menu.direction = .bottom
        return menu
    }()
    
    private let heightButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "How tall are you in cm?", framerTitle: "-", type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showHeightDrop), for: .touchUpInside)
        return button
    }()
    
    private let weightButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your weight in kg?", framerTitle: "-", type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showWeightDrop), for: .touchUpInside)
        return button
    }()
    
    private let dietButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your diet type?", framerTitle: "-" , type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showDietDrop), for: .touchUpInside)
        return button
    }()
    
    private let bodyGoalsButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your body goal?", framerTitle: "-" , type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showBodyGoalDrop), for: .touchUpInside)
        return button
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
        let button = SecondaryAuthButtons(titleOne: "What is your Age?", framerTitle: "-", type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showAgeDrop), for: .touchUpInside)
        return button
    }()
    
    private let activityButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "How is your physical activity?", framerTitle: "-" , type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showActivityDrop), for: .touchUpInside)
        return button
    }()
    
    private let genderButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What's your gender?", framerTitle: "-" , type: .system, titleOneSize: 15, framerTitleSize: 13, overallColor: .black)
        button.addTarget(self, action: #selector(showGenderDrop), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: AuthButton = {
        let button = AuthButton(title: "Save information", type: .system, color: .black, backGroundColor: .white)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleSaveInfo), for: .touchUpInside)
        return button
    }()
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isView == false {
            configureNavigationBar(withTitle: "Personal Information", titleView: nil, backgroundcolor: .black, titleColor: .white, prefersLargeTitles: false)
        } else {
            navigationController?.navigationBar.isHidden = true
        }
        
        print("what is it? \(isView)")
        
        configureUI()
        configure()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.5 + 40)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let vv = UIView()
        scrollView.addSubview(vv)
        vv.backgroundColor = .white
        vv.anchor(top: scrollView.topAnchor, left: view.leftAnchor,bottom: scrollView.bottomAnchor,right: view.rightAnchor,paddingBottom: 100)
        
        if isView == true {
            vv.layer.shadowOffset = CGSize(width: 1.0, height: 0.7)
            vv.layer.shadowOpacity = 1
            vv.layer.shadowColor = UIColor.black.cgColor
            vv.layer.cornerRadius = 12
        } else {
            
        }
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptiveInfoLabel])
        stack.axis = .vertical
        stack.spacing = 4
        vv.addSubview(stack)
        vv.bringSubviewToFront(stack)
        stack.anchor(top: vv.topAnchor, left: vv.leftAnchor, right: vv.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 6)
        
        
        weightMenu.anchorView = weightButton
        heightMenu.anchorView = heightButton
        dietTypeMenu.anchorView = dietButton
        bodyTypeMenu.anchorView = bodyGoalsButton
        ageMenu.anchorView = ageButton
        activityMenu.anchorView = activityButton
        genderMenu.anchorView = genderButton
        
        let buttonStack = UIStackView(arrangedSubviews: [weightButton,heightButton,dietButton,bodyGoalsButton,ageButton,activityButton, genderButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 15
        scrollView.addSubview(buttonStack)
        buttonStack.anchor(top: stack.bottomAnchor, left: vv.leftAnchor,bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingTop: 50,paddingLeft: 35,paddingBottom: 0, paddingRight: 45)
        scrollView.addSubview(saveButton)
        saveButton.centerX(inView: self.view)
        saveButton.anchor(top: buttonStack.bottomAnchor, paddingTop: 20, width: 200, height: 50)
        
        
    }
    
    func configure() {
        
        if isView == true {
            self.titleLabel.text = "Lack Information"
            self.descriptiveInfoLabel.text = "You haven't filled up some of your personal information.To be able to give you certain and the most efficient program or diet we need your body values."
        } else {
            self.titleLabel.text = "Personal Information"
            self.descriptiveInfoLabel.text = "On this page you can edit your personal informations. Please keep in mind that your diet and program are given through for efficiency"
        }
        
        bodyGoalsButton.setTitle("\(self.user?.bodyGoalType ?? "Fill up")", for: .normal)
        dietButton.setTitle("\(self.user?.dietType ?? "Fill up")", for: .normal)
        heightButton.setTitle("\(self.user?.height ?? 0)", for: .normal)
        weightButton.setTitle("\(self.user?.weight ?? 0)", for: .normal)
        genderButton.setTitle("\(self.user?.gender ?? "Fill up")", for: .normal)
        activityButton.setTitle("\(self.user?.activity ?? "Fill up")", for: .normal)
        ageButton.setTitle("\(self.user?.age ?? 0)", for: .normal)
        
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSaveInfo() {
        guard let activity = activityButton.titleLabel?.text else { return }
        guard let gender = genderButton.titleLabel?.text else { return }
        guard let age = ageButton.titleLabel?.text else { return }
        guard let dietTypes = dietButton.titleLabel?.text else { return }
        guard let bodyGoalsType = bodyGoalsButton.titleLabel?.text else { return }
        guard let height = heightButton.titleLabel?.text else { return }
        guard let weight = weightButton.titleLabel?.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.user?.uid = currentUid
        self.user?.dietType = dietTypes
        self.user?.bodyGoalType = bodyGoalsType
        self.user?.height = Int(height) ?? self.user?.height
        self.user?.weight = Int(weight) ?? self.user?.weight
        self.user?.activity = activity
        self.user?.gender = gender
        self.user?.age = Int(age) ?? 25
        
        // BMR
        let h = Double(self.user?.height ?? 0)
        let w = Double(self.user?.weight ?? 0)
        let a = Double(self.user?.age ?? 0)
        let bmrW = userIsMale ? w * 13.397 : w * 9.247
        let bmrH = userIsMale ? h * 4.799 : h * 3.098
        let bmrA = userIsMale ? a * 5.677 : a * 4.330
        let bmrRandom = userIsMale ? 88.362 : 447.593
        
        let bmrResult = bmrW + bmrH - bmrA + bmrRandom
        
        self.user?.bmr = bmrResult
        
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
        
        let bodyGoal = self.user?.bodyGoalType
        
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
        
        self.user?.requiredCalories = self.bmr
        guard let user = self.user else { return }
        Service.saveUserData(user: user) { (err, ref) in
                self.user = user
                
                if self.isView == true {
                    self.delegate?.dismissal(self)
                } else {
                    self.dismiss(animated: true) {
                        self.delegate?.dismissalFromController(self)
                        print("what's good?")
                    }
                    
                
            }
        }
    }
    
    @objc func showBodyGoalDrop() {
        bodyTypeMenu.show()
        bodyTypeMenu.selectionAction = { index, item  in
            self.bodyGoalsButton.setTitle("\(self.bodyTypeMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func showDietDrop() {
        dietTypeMenu.show()
        dietTypeMenu.selectionAction = { index, item  in
            self.dietButton.setTitle("\(self.dietTypeMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func showHeightDrop() {
        heightMenu.show()
        heightMenu.selectionAction = { index, item  in
            self.heightButton.setTitle("\(self.heightMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func showWeightDrop() {
        weightMenu.show()
        weightMenu.selectionAction = { index, item  in
            self.weightButton.setTitle("\(self.weightMenu.selectedItem ?? "")", for: .normal)
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
}
