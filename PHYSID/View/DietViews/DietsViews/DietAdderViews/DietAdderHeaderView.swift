//
//  DietAdderHeaderView.swift
//  PHYSID
//
//  Created by Apple on 10.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown

protocol DietAdderHeaderViewDelegate: class {
    func saveDietInfo(_ header: DietAdderHeaderView)
    func didTapChangeProfilePhoto()
    
}

class DietAdderHeaderView: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    weak var delegate: DietAdderHeaderViewDelegate?
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add the diet", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(saveFood), for: .touchUpInside)
        return button
    }()
    
    let bigView: UIImageView = {
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
    
    let dietTitleLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "DIET TITLE"
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
    
    let minCaloriesLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "120"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Min. Calories"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let maxCaloriesLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "26"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.setDimensions(height: 21, width: 30)
        let descriptiveLabel = UILabel()
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.text = "Max. Calories"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let fatPercentage: UITextField = {
        let label = UITextField()
        label.placeholder = "15"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Fats %"
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
        descriptiveLabel.text = "Carbs %"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, paddingTop: 2)
        return label
    }()
    
    let proteinsLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "60"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Proteins %"
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
    
    let av = UIView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let vv = UIView()
        addSubview(vv)
        vv.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 0,paddingLeft: 0.1,paddingRight: 0.1, height: 320)
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
        
        addSubview(saveButton)
        saveButton.anchor(top: bigView.bottomAnchor, right: bigView.rightAnchor, width: 110, height: 30)
        
        addSubview(foodImageButton)
        foodImageButton.anchor(top: bigView.topAnchor, left: bigView.leftAnchor, bottom: bigView.bottomAnchor, right: bigView.rightAnchor)
        foodImageButton.layer.cornerRadius = 50
        
        addSubview(dietTitleLabel)
        dietTitleLabel.anchor(top: vv.bottomAnchor, paddingTop: 20)
        dietTitleLabel.centerX(inView: self)
        
        dietTypeMenu.anchorView = dietButton
        
        
        addSubview(dietButton)
        dietButton.anchor(top: dietTitleLabel.bottomAnchor, paddingTop: 8, height: 40)
        dietButton.centerX(inView: dietTitleLabel)
        
        addSubview(firstLine)
        firstLine.anchor(top: dietButton.bottomAnchor, paddingTop: 16, width: 200, height: 0.6)
        firstLine.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [minCaloriesLabel, UIView(), maxCaloriesLabel, UIView(), carbsLabel, UIView(), fatPercentage, UIView(), proteinsLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        addSubview(stack)
        stack.anchor(top: firstLine.bottomAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 40, paddingRight: 80)
        
        addSubview(secondLine)
        secondLine.anchor(top: stack.bottomAnchor, paddingTop: 40, width: 340, height: 0.6)
        
        secondLine.centerX(inView: self)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor, paddingTop: 16, height: 250)
         
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
        guard let dietName = dietTitleLabel.text else { return }
        guard let dietType = dietButton.titleLabel!.text else { return }
        guard let descriptiveInfo = descriptionLabel.text else { return }
        guard let image = bigView.image else { return }
        guard let minCalories = minCaloriesLabel.text else { return }
        guard let maxCalories = maxCaloriesLabel.text else { return }
        guard let carbsPercentage = carbsLabel.text else { return }
        guard let fatsPercentage = fatPercentage.text else { return }
        guard let proteinsPercentage = proteinsLabel.text else { return }
        
        Service.uploadImage(image: image) { (profileImageUrl) in
            let dietCredentials = DietCredentials.init(dietType: dietType, dietDescriptiveBio: descriptiveInfo, dietTitle: dietName, dietDefinitiveImageUrl: profileImageUrl, isFree: true, minCalories: Int(minCalories)!, maxCalories: Int(maxCalories)!, carbsPercentage: Int(carbsPercentage)!,proteinsPercentage: Int(proteinsPercentage)!, fatsPercentage: Int(fatsPercentage)!)
      
            Service.uploadDiet(credentials: dietCredentials) { (err, ref) in
                print("hrrrr")
            }
        }
        
        delegate?.saveDietInfo(self)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
}
