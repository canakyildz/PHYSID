//
//  FoodAdderHeader.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown

protocol FoodAdderHeaderDelegate: class {
    func saveFoodInfo(_ header: FoodAdderHeader)
    func didTapChangeProfilePhoto()
    
}

class FoodAdderHeader: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    weak var delegate: FoodAdderHeaderDelegate?
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add the food", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(saveFood), for: .touchUpInside)
        return button
    }()
    
    let foodImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "veg"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let foodImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.addTarget(self, action: #selector(handleSetFoodImage), for: .touchUpInside)
        return button
    }()
    
    let foodNameLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "FOOD NAME"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let dietTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Standard", "Vegeterian", "Vegan", "Keto", "Paleo"]
        menu.direction = .bottom
        return menu
    }()
    
    private let dietButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitle("Food type", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(showDietDrop), for: .touchUpInside)
        return button
    }()
    
    lazy var descriptionLabel: InputTextView = {
        let tf = InputTextView()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .black
        return tf
    }()
    
    let caloriesLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "120"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Calories"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let proteinsLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "26"
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
    
    let fatsLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "15"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Fats"
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let carbsLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "60"
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
    
    let recipeVideoUrl: UITextField = {
        let label = UITextField()
        label.placeholder = "Video Url"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        return label
    }()
    

    
    private let firstLine = UnderLineView()
    private let secondLine = UnderLineView()
    private let thirdLine = UnderLineView()
    private let fourthLine = UnderLineView()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(foodImage)
        foodImage.anchor(top: topAnchor, left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, paddingBottom: 700)
        
        addSubview(saveButton)
        saveButton.anchor(top: foodImage.bottomAnchor, right: foodImage.rightAnchor, width: 110, height: 30)
        
        addSubview(foodImageButton)
        foodImageButton.anchor(top: foodImage.topAnchor, left: foodImage.leftAnchor, bottom: foodImage.bottomAnchor, right: foodImage.rightAnchor)
        foodImageButton.layer.cornerRadius = 50
        
        addSubview(foodNameLabel)
        foodNameLabel.anchor(top: foodImage.bottomAnchor, paddingTop: 20)
        foodNameLabel.centerX(inView: self)
        
        dietTypeMenu.anchorView = dietButton
        
        
        addSubview(dietButton)
        dietButton.anchor(top: foodNameLabel.bottomAnchor, paddingTop: 8, height: 40)
        dietButton.centerX(inView: foodNameLabel)
        
        addSubview(firstLine)
        firstLine.anchor(top: dietButton.bottomAnchor, paddingTop: 16, width: 200, height: 0.6)
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
        descriptionLabel.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor, paddingTop: 16, height: 250)
        
        addSubview(thirdLine)
        thirdLine.anchor(top: descriptionLabel.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor,paddingTop: 16, paddingLeft: 0, paddingRight: 0, height: 0.3)
        
        addSubview(RecipeLabel)
        RecipeLabel.anchor(top: thirdLine.bottomAnchor, paddingTop: 16)
        RecipeLabel.centerX(inView: thirdLine)
        
        addSubview(recipeVideoUrl)
        recipeVideoUrl.anchor(top: RecipeLabel.bottomAnchor,left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 15, paddingLeft: 4, paddingRight: 4)
        recipeVideoUrl.centerX(inView: self)
        
        addSubview(fourthLine)
        fourthLine.anchor(top: recipeVideoUrl.bottomAnchor, left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 20, height: 0.3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func showDietDrop() {
        dietTypeMenu.show()
        dietTypeMenu.selectionAction = { index, item  in
            self.dietButton.setTitle("\(self.dietTypeMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func handleSetFoodImage() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    @objc func saveFood() {
        guard let foodname = foodNameLabel.text else { return }
        guard let foodType = dietButton.titleLabel!.text else { return }
        guard let calories = caloriesLabel.text else { return }
        guard let carbs = carbsLabel.text else { return }
        guard let proteins = proteinsLabel.text else { return }
        guard let fats = fatsLabel.text else { return }
        guard let descriptiveInfo = descriptionLabel.text else { return }
        guard let recipeVideoUrl = recipeVideoUrl.text else { return }
        guard let image = foodImage.image else { return }
        Service.uploadImage(image: image) { (profileImageUrl) in
            let credentials = FoodCredentials.init(foodName: foodname, foodType: foodType, calories: Int(calories)!, carbs: Int(carbs)!, proteins: Int(proteins)!, fats: Int(fats)!, descriptiveInfo: descriptiveInfo, foodImageUrl: profileImageUrl, recipeVideoUrl: recipeVideoUrl)
            
            Service.uploadFood(credentials: credentials) { (err, ref) in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
        }
        
        delegate?.saveFoodInfo(self)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
}
