//
//  DietContentHeaderView.swift
//  PHYSID
//
//  Created by Apple on 10.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol DietContentHeaderViewDelegate: class {
    func handleRemovalOfFood()
}

class DietContentHeaderView: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    var diet: Diet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: DietContentHeaderViewDelegate?
    
    let bigView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Byron_Fleet0010-600x900"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    
    let userProfileImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        return iv
    }()
    
    lazy var userNameLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Can Akyıldız aşsdaşd şaskdşaskdlsşadkşla dsalşkdlşaskdlşas k", for: .normal)
        button.setTitleColor(.black, for: .normal)
        let customFont = UIFont(name: "Helvetica Bold", size: 12)
        button.titleLabel?.font = customFont
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        
        return button
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "iwontsayagain"),for: .normal)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1.5
        button.layer.shadowOpacity = 0
        button.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-topic-24"),for: .normal)
        button.setDimensions(height: 23, width: 24)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    
    let savePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-bookmark-24"),for: .normal)
        button.setDimensions(height: 26, width: 26)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    lazy var professionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Personal Trainer, Conditioner", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        let customFont = UIFont(name: "Helvetica", size: 12)
        label.font = customFont
        label.text = " 3 likes"
        return label
    }()
    
    let dietTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Efficient Diet For Fat Loss"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    let dietTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Vegeterian, Vegan"
        label.textColor = .darkGray
        label.font = UIFont.customFont(name: "Helvetica Light", size: 17)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum,omes from a line in section 1.10.32.Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum,omes from a line in section 1.10.32."
        label.numberOfLines = 100
        label.textAlignment = .left
        label.font = UIFont.customFont(name: "Helvetica", size: 14)
        return label
    }()
    
    let caloriesScaling: UILabel = {
        let label = UILabel()
        label.text = "120"
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Calorie Range"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let maxCaloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "26"
        label.setDimensions(height: 21, width: 30)
        let descriptiveLabel = UILabel()
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.text = "Max. Calories"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let fatPercentage: UILabel = {
        let label = UILabel()
        label.text = "15"
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Fats %"
        descriptiveLabel.numberOfLines = 2
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let carbsLabel: UILabel = {
        let label = UILabel()
        label.text = "60"
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Carbs %"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let proteinsLabel: UILabel = {
        let label = UILabel()
        label.text = "60"
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Proteins %"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 11)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    lazy var removeFoodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(handleRemoveFood), for: .touchUpInside)
        return button
    }()
    
    private let firstLine = UnderLineView()
    private let secondLine = UnderLineView()
    private let thirdLine = UnderLineView()
    private let fourthLine = UnderLineView()
    private let av = UIView()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,paddingTop: -30,paddingLeft: 0.1,paddingRight: 0.1, height: 320)
        vv.addSubview(bigView)
        bigView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingBottom: -20)
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOffset = CGSize(width: 0.2, height: 3)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowRadius = 2.6
        
        addSubview(av)
        vv.bringSubviewToFront(av)
        av.anchor(top: bigView.bottomAnchor, left: bigView.leftAnchor,right: bigView.rightAnchor, paddingTop: -30, height: 60)
        av.backgroundColor = .white
        av.layer.cornerRadius = 30
        
        addSubview(dietTitleLabel)
        dietTitleLabel.anchor(top: vv.bottomAnchor, paddingTop: 20)
        dietTitleLabel.centerX(inView: self)
        
        addSubview(dietTypeLabel)
        dietTypeLabel.anchor(top: dietTitleLabel.bottomAnchor, paddingTop: 8)
        dietTypeLabel.centerX(inView: dietTitleLabel)
        
        addSubview(firstLine)
        firstLine.anchor(top: dietTypeLabel.bottomAnchor, paddingTop: 16, width: 200, height: 0.6)
        firstLine.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [caloriesScaling, carbsLabel, fatPercentage, proteinsLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        addSubview(stack)
        stack.anchor(top: firstLine.bottomAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 80, paddingRight: 80)
        
        addSubview(secondLine)
        secondLine.anchor(top: stack.bottomAnchor, paddingTop: 40, width: 340, height: 0.6)
        secondLine.centerX(inView: self)
        
        addSubview(userProfileImage)
        userProfileImage.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor,paddingTop: 20, width: 35, height: 35)
        
        let nameStack = UIStackView(arrangedSubviews: [userNameLabel, professionButton])
        nameStack.axis = .vertical
        nameStack.spacing = -10
        nameStack.alignment = .leading
        addSubview(nameStack)
        nameStack.anchor(left: userProfileImage.rightAnchor, paddingLeft: 4, width: 160)
        nameStack.backgroundColor = .clear
        nameStack.centerY(inView: userProfileImage)
        
        
        let userStack = UIStackView(arrangedSubviews: [UIView(), UIView(), likeButton,likesLabel, savePostButton])
        userStack.axis = .horizontal
        userProfileImage.setDimensions(height: 35, width: 35)
        userProfileImage.layer.cornerRadius = 15
        userStack.distribution = .equalCentering
        addSubview(userStack)
        userStack.anchor(top: secondLine.bottomAnchor,left: nameStack.rightAnchor, right: secondLine.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 35)
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: userStack.bottomAnchor,left: secondLine.leftAnchor,bottom: bottomAnchor,  right: secondLine.rightAnchor, paddingTop: 16)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleRemoveFood() {
        delegate?.handleRemovalOfFood()
    }
    
    @objc func handleSave() {
        
    }
    
    @objc func handleComment() {
        
    }
    
    @objc func handleUsernameTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }

    
    // MARK: - Helpers
    
        func configure() {
            guard let diet = diet else { return }
            guard let dietDefinitiveImageUrl = diet.dietDefinitiveImageUrl else { return }
            guard let dietProfileImageUrl = URL(string: dietDefinitiveImageUrl) else { return }
            bigView.sd_setImage(with: dietProfileImageUrl)
            dietTitleLabel.text = diet.dietTitle
            dietTypeLabel.text = diet.dietType
            let attributedText = NSAttributedString(string: "\(diet.minCalories)-\(diet.maxCalories)",
                                                    attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Bold", size: 20)])
            caloriesScaling.attributedText = attributedText
            carbsLabel.text = "\(diet.carbsPercentage)"
            proteinsLabel.text = "\(diet.proteinsPercentage)"
            fatPercentage.text = "\(diet.fatsPercentage)"
            descriptionLabel.text = diet.dietDescriptiveBio
            Service.fetchUser(withUid: diet.ownerId) { (user) in
                self.userNameLabel.setTitle(user.name, for: .normal)
                self.professionButton.setTitle(user.professionType, for: .normal)
            }
    
        }
}
