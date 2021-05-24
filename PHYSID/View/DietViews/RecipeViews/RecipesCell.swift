//
//  RecipesCell.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class RecipesCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var food: Food? {
        didSet { configure() }
    }
        
    let foodImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "veg"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let foodNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Light paneer curry"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 15)
        return label
    }()
    
    let dietTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Vegeterian"
        label.font = UIFont.customFont(name: "Helvetica", size: 14)
        return label
    }()
    
    let nutritionalValues: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica Light", size: 14)
        return label
    }()
    

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 1)
        vv.layer.shadowOpacity = 0.6
        vv.layer.shadowRadius = 2
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.setDimensions(height: 70, width: 70)
        vv.anchor(top: topAnchor,left: leftAnchor,paddingTop: 20, paddingLeft: 12)
        vv.addSubview(foodImage)
        foodImage.layer.cornerRadius = 5
        foodImage.setDimensions(height: 70, width: 70)
        foodImage.centerY(inView: vv)
        foodImage.centerX(inView: vv)
        
        

        
        let stack = UIStackView(arrangedSubviews: [foodNameLabel, dietTypeLabel, nutritionalValues])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(left: vv.rightAnchor, paddingLeft: 6)
        stack.centerY(inView: foodImage )
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let food = food else { return }
        guard let profileImageUrl = food.foodProfileImageUrl else { return }
        guard let foodProfileImageUrl = URL(string: profileImageUrl) else { return }
        foodImage.sd_setImage(with: foodProfileImageUrl)
        foodNameLabel.text = food.foodName
        dietTypeLabel.text = food.foodTypeViewModel
        // put these in a view model later on
        
        print(food.calories)
        
        let attributedText = NSAttributedString(string: "Calories: \(food.calories), Proteins: \(food.proteins), Fats: \(food.fats), Carbs: \(food.carbs)",
                                                attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Light", size: 13)
])
    
        nutritionalValues.attributedText = attributedText
    }
    
}
