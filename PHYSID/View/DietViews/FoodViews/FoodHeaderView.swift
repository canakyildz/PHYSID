//
//  FoodHeaderView.swift
//  PHYSID
//
//  Created by Apple on 20.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol FoodHeaderViewDelegate: class {
    func handlePlayVideo(withUrl recipeVideoUrl: String)
    func handleRemovalOfFood()
}

class FoodHeaderView: UICollectionReusableView {
    
    
    // MARK: - Properties
        
    var food: Food! {
        didSet { configureUI() }
    }
    
    weak var delegate: FoodHeaderViewDelegate?
    
    let foodView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let foodNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let dietTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.06665418297, green: 0.0666738525, blue: 0.06665291637, alpha: 1)
        label.text = ""
        label.numberOfLines = 100
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Calories"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let proteinsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.setDimensions(height: 21, width: 30)
        let descriptiveLabel = UILabel()
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.text = "Proteins"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let fatsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Fats"
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let carbsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Carbs"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    private let RecipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe video"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var recipeVideoView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "veg"))
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        iv.setDimensions(height: 150, width: 150)
        let playview = UIImageView(image: #imageLiteral(resourceName: "icons8-play-50").withTintColor(#colorLiteral(red: 0.05417195431, green: 0.05417195431, blue: 0.05417195431, alpha: 1)))
        playview.setDimensions(height: 50, width: 50)
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePlayVideo))
        iv.addGestureRecognizer(tap)
        
//        iv.addSubview(visualEffectView)
        visualEffectView.alpha = 0.5
        visualEffectView.fillSuperview()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.addSubview(playview)
        playview.centerY(inView: iv)
        playview.centerX(inView: iv)
        return iv
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
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor, left: leftAnchor,right: rightAnchor, height: 400)
        vv.layer.shadowOffset = CGSize(width: 1, height: 1.5)
        vv.layer.shadowOpacity = 0.4
        vv.layer.shadowRadius = 1
        vv.layer.shadowColor = UIColor.black.cgColor
        
        vv.addSubview(foodView)
        foodView.anchor(top: vv.topAnchor, left: vv.leftAnchor,bottom: vv.bottomAnchor, right: vv.rightAnchor)
        
 
        
        addSubview(foodNameLabel)
        foodNameLabel.anchor(top: foodView.bottomAnchor, paddingTop: 20)
        foodNameLabel.centerX(inView: self)
        
        addSubview(dietTypeLabel)
        dietTypeLabel.anchor(top: foodNameLabel.bottomAnchor, paddingTop: 8)
        dietTypeLabel.centerX(inView: foodNameLabel)
        
        addSubview(firstLine)
        firstLine.anchor(top: dietTypeLabel.bottomAnchor, paddingTop: 16, width: 200, height: 0.6)
        firstLine.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [caloriesLabel, carbsLabel, proteinsLabel, fatsLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        addSubview(stack)
        stack.anchor(top: firstLine.bottomAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 80, paddingRight: 80)
        
        addSubview(secondLine)
        secondLine.anchor(top: stack.bottomAnchor, paddingTop: 40, width: 340, height: 0.6)
        
        secondLine.centerX(inView: self)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor, paddingTop: 16)
        
        addSubview(thirdLine)
        thirdLine.anchor(top: descriptionLabel.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor,paddingTop: 16, paddingLeft: 0, paddingRight: 0, height: 0.3)
        
        addSubview(RecipeLabel)
        RecipeLabel.anchor(top: thirdLine.bottomAnchor, paddingTop: 16)
        RecipeLabel.centerX(inView: thirdLine)
        
        addSubview(recipeVideoView)
        recipeVideoView.anchor(top: RecipeLabel.bottomAnchor, paddingTop: 15, width: 150, height: 150)
        recipeVideoView.centerX(inView: self)
        
        addSubview(fourthLine)
        fourthLine.anchor(top: recipeVideoView.bottomAnchor, left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 20, height: 0.3)
        
        //        addSubview(backButton)
        //        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 40, paddingLeft: 20)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            if user.isAdmin {
                self.addSubview(self.removeFoodButton)
                self.bringSubviewToFront(self.removeFoodButton)
                self.removeFoodButton.anchor(top: self.foodView.bottomAnchor, left: self.leftAnchor, paddingTop: 6, paddingLeft: 6, width: 70, height: 30)
                self.removeFoodButton.isEnabled = true
                self.removeFoodButton.isHidden = false
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleRemoveFood() {
        delegate?.handleRemovalOfFood()
    }
    
    @objc func handlePlayVideo() {
        guard let recipeVideoUrl = food.recipeVideoUrl else { return }
        if recipeVideoUrl == "" {
            
        } else {
            delegate?.handlePlayVideo(withUrl: recipeVideoUrl)

        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let food = food else { return }
        guard let profileImageUrl = food.foodProfileImageUrl else { return }
        guard let foodProfileImageUrl = URL(string: profileImageUrl) else { return }
        foodView.sd_setImage(with: foodProfileImageUrl)
        foodNameLabel.text = food.foodName.uppercased()
        dietTypeLabel.text = food.foodTypeViewModel
        caloriesLabel.text = "\(food.calories)"
        carbsLabel.text = "\(food.carbs)"
        proteinsLabel.text = "\(food.proteins)"
        fatsLabel.text = "\(food.fats)"
        descriptionLabel.text = food.foodDescriptiveBio
        if food.recipeVideoUrl == "" {
            recipeVideoView.alpha = 0
        } else {
            recipeVideoView.sd_setImage(with: URL(string: profileImageUrl))

        }
        
    }
}
