//
//  RegistrationSecondaryView.swift
//  PHYSID
//
//  Created by Apple on 23.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown
import Firebase

class RegistrationSecondaryController: UIViewController {
    
    // MARK: - Properties
    
    
    private var user: User
    weak var delegate: AuthenticationCompletionDelegate?
    
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
        label.text = "Let us know \nmore about you "
        label.alpha = 0
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
        let button = SecondaryAuthButtons(titleOne: "How tall are you in cm?", framerTitle: "-", type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showHeightDrop), for: .touchUpInside)
        return button
    }()
    
    private let weightButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your weight in kg?", framerTitle: "-", type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showWeightDrop), for: .touchUpInside)
        return button
    }()
    
    private let dietButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is your diet type?", framerTitle: "-" , type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showDietDrop), for: .touchUpInside)
        return button
    }()
    
    private let bodyGoalsButton: SecondaryAuthButtons = {
        let button = SecondaryAuthButtons(titleOne: "What is possibly be your body goal?", framerTitle: "-" , type: .system, titleOneSize: 18, framerTitleSize: 16, overallColor: .white)
        button.addTarget(self, action: #selector(showBodyGoalDrop), for: .touchUpInside)
        return button
    }()
    
    private let professionField: CustomTextField = {
        let label = CustomTextField(titleholder: "Do you have a profession?")
        return label
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
        
        weightMenu.anchorView = weightButton
        heightMenu.anchorView = heightButton
        dietTypeMenu.anchorView = dietButton
        bodyTypeMenu.anchorView = bodyGoalsButton
        
        let stack = UIStackView(arrangedSubviews: [dietButton,bodyGoalsButton, heightButton, weightButton, professionField])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: letUsKnowMoreLabel.bottomAnchor, left: letUsKnowMoreLabel.leftAnchor, right: secondView.rightAnchor, paddingTop: 20, paddingRight: 60)
        
        view.addSubview(saveButton)
        saveButton.centerX(inView: stack)
        saveButton.anchor(top: stack.bottomAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 30,paddingBottom: 20, width: 200)
        
        
    }
    
    // MARK: - Selectors
    
    @objc func handleSaveInfo() {
        guard let dietTypes = dietButton.titleLabel?.text else { return }
        guard let bodyGoalsType = bodyGoalsButton.titleLabel?.text else { return }
        guard let height = heightButton.titleLabel?.text else { return }
        guard let weight = weightButton.titleLabel?.text else { return }
        guard let professionType = professionField.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.user.uid = currentUid
        self.user.dietType = dietTypes
        self.user.bodyGoalType = bodyGoalsType
        self.user.height = Int(height) ?? self.user.height
        self.user.weight = Int(weight) ?? self.user.weight
        self.user.professionType = professionType
        
        Service.saveUserData(user: user) { (err, ref) in
                Service.fetchUser(withUid: currentUid) { (user) in
                    self.user = user
                    let controller = ThirdRegistrationController(user: user)
                    self.navigationController?.pushViewController(controller, animated: true)

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
    
    // MARK: - Helpers
    
}
