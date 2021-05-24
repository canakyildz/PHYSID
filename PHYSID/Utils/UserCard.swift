//
//  UserCard.swift
//  PHYSID
//
//  Created by Apple on 26.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class UserCard: UIView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    let userProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    let defImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lastoneiguess").withTintColor(.lightGray))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full name"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 14)
        return label
    }()
    
    let dietNbodyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "United States of America"
        label.numberOfLines = 2
        label.font = UIFont.customFont(name: "Helvetica", size: 13)
        return label
    }()
    
    let userFeaturesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica", size: 13)
        return label
    }()
    
    let ageNgenderLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica", size: 13)
        return label
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica", size: 13)
        return label
    }()
    
    let dailyRequiredCaloriesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica", size: 13.4)
        return label
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 0.1)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowRadius = 2.7
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.setDimensions(height: 105, width: 100)
        vv.anchor(top: topAnchor,left: leftAnchor,paddingTop: 6, paddingLeft: 6)
        
        vv.addSubview(userProfileImage)
        userProfileImage.addSubview(defImage)
        defImage.fillSuperview()
        userProfileImage.layer.cornerRadius = 8
        userProfileImage.setDimensions(height: 105, width: 100)
        userProfileImage.centerY(inView: vv)
        userProfileImage.centerX(inView: vv)
        
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel,dailyRequiredCaloriesLabel, dietNbodyInfoLabel, userFeaturesLabel, activityLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(left: vv.rightAnchor, right: rightAnchor ,paddingLeft: 6, paddingRight: 6)
        stack.centerY(inView: userProfileImage)
        
    }
    
    func configure() {
        guard let user = self.user else { return }
        activityLabel.text = "Activity: \(user.activity ?? "hasn't been defined yet")"
        dailyRequiredCaloriesLabel.text = "Must-take daily calories: \(Int(user.requiredCalories ?? 0)).36"

        
        let nameLabelAttributedText = NSMutableAttributedString(string: "\(user.name ?? "Full Name"), ",
                                                                attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Bold", size: 15)])
        nameLabelAttributedText.append(NSAttributedString(string: "\(user.age ?? 0)",
                                                          attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 14)]))


        userNameLabel.attributedText = nameLabelAttributedText
        
        let attributedText = NSAttributedString(string: "Height: \(user.height ?? 0), Weight: \(user.weight ?? 0)",
                                                attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 13)])
        
        self.userFeaturesLabel.attributedText = attributedText
        
        
        let attributedTexterino = NSAttributedString(string: "Diet: \(user.dietType ?? "Standard"), Goal: \(user.bodyGoalType ?? "No goals yet")",
                                                     attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 13)])
        
        self.dietNbodyInfoLabel.attributedText = attributedTexterino
        
        guard let profileImageUrl = user.profileImageUrl else { return }
        if profileImageUrl == "" {
            defImage.isHidden = false
            
        } else {
            defImage.isHidden = true
            let unnecessaryUrling = URL(string: profileImageUrl)
            userProfileImage.sd_setImage(with: unnecessaryUrling)
        }
        
        
        
        
    }
    
    
}
