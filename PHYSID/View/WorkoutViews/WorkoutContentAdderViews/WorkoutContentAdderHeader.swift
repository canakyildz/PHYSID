//
//  WorkoutContentAdderHeader.swift
//  PHYSID
//
//  Created by Apple on 2.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown

protocol WorkoutContentAdderHeaderDelegate: class {
    func saveWorkoutInfo(_ header: WorkoutContentAdderHeader)
    func didTapChangeProfilePhoto()
    
}

class WorkoutContentAdderHeader: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    weak var delegate: WorkoutContentAdderHeaderDelegate?
    
    private var workoutContentAPTypes: [String]? = [String]()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add the content", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(saveFood), for: .touchUpInside)
        return button
    }()
    
    let workoutImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Ekran Resmi 2020-08-21 16.33.21"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let workoutImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.addTarget(self, action: #selector(handleSetWorkoutImage), for: .touchUpInside)
        return button
    }()
    
    let workoutNameLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "WORKOUT CONTENT TITLE"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let workoutTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Full body", "Shoulders", "Arms", "Back", "Abs", "Legs", "Chest", "Cardio"]
        menu.direction = .bottom
        return menu
    }()
    
    private let workoutTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitle("Workout type", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(showWorkoutTypeDrop), for: .touchUpInside)
        return button
    }()

    let assignedPurposalTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["My Program", "Whole Workouts", "One Move", "CrossFit", "Condition Based", "My Favorites", "Chest", "Cardio"]
        menu.direction = .bottom
        return menu
    }()
    
    private let assignedPurposalTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitle("Assigned purposal type", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(showAPTypeDrop), for: .touchUpInside)
        return button
    }()
    
    lazy var descriptionLabel: InputTextView = {
        let tf = InputTextView()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .black
        return tf
    }()
    
    let equipmentLabel: InputTextView = {
        let label = InputTextView()
        label.placeholderLabel.text = "Equipments required?"
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Equipments"
        descriptiveLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(left: label.leftAnchor, bottom: label.topAnchor, paddingBottom: 0)
        return label
    }()
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Instruction video"
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
        
        addSubview(workoutImage)
        workoutImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 300)
        
        addSubview(saveButton)
        saveButton.anchor(top: workoutImage.bottomAnchor, right: workoutImage.rightAnchor, width: 110, height: 30)
        
        addSubview(workoutImageButton)
        workoutImageButton.anchor(top: workoutImage.topAnchor, left: workoutImage.leftAnchor, bottom: workoutImage.bottomAnchor, right: workoutImage.rightAnchor)
        workoutImageButton.layer.cornerRadius = 50
        
        addSubview(workoutNameLabel)
        workoutNameLabel.anchor(top: workoutImage.bottomAnchor, paddingTop: 20)
        workoutNameLabel.centerX(inView: self)
        
        workoutTypeMenu.anchorView = workoutTypeButton
        
        
        addSubview(workoutTypeButton)
        workoutTypeButton.anchor(top: workoutNameLabel.bottomAnchor, paddingTop: 8, height: 40)
        workoutTypeButton.centerX(inView: workoutNameLabel)
        
        assignedPurposalTypeMenu.anchorView = assignedPurposalTypeButton
        
        addSubview(assignedPurposalTypeButton)
        assignedPurposalTypeButton.anchor(top: workoutTypeButton.bottomAnchor, paddingTop: 8, height: 40)
        assignedPurposalTypeButton.centerX(inView: workoutTypeButton)
        
        
        addSubview(firstLine)
        firstLine.anchor(top: assignedPurposalTypeButton.bottomAnchor, paddingTop: 16, width: 200, height: 0.6)
        firstLine.centerX(inView: self)
        
        addSubview(equipmentLabel)
        equipmentLabel.anchor(top: firstLine.bottomAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 45, paddingLeft: 80, paddingRight: 80)

        
        addSubview(secondLine)
        secondLine.anchor(top: equipmentLabel.bottomAnchor, paddingTop: 40, width: 340, height: 0.6)
        
        secondLine.centerX(inView: self)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor, paddingTop: 16, height: 250)
        
        addSubview(thirdLine)
        thirdLine.anchor(top: descriptionLabel.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor,paddingTop: 16, paddingLeft: 0, paddingRight: 0, height: 0.3)
        
        addSubview(instructionLabel)
        instructionLabel.anchor(top: thirdLine.bottomAnchor, paddingTop: 16)
        instructionLabel.centerX(inView: thirdLine)
        
        addSubview(recipeVideoUrl)
        recipeVideoUrl.anchor(top: instructionLabel.bottomAnchor,left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 15, paddingLeft: 4, paddingRight: 4)
        recipeVideoUrl.centerX(inView: self)
        
        addSubview(fourthLine)
        fourthLine.anchor(top: recipeVideoUrl.bottomAnchor, left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 20, height: 0.3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func showWorkoutTypeDrop() {
        workoutTypeMenu.show()
        workoutTypeMenu.selectionAction = { index, item  in
            self.workoutTypeButton.setTitle("\(self.workoutTypeMenu.selectedItem ?? "")", for: .normal)

        }
    }
    
    @objc func showAPTypeDrop() {
        assignedPurposalTypeMenu.show()
        assignedPurposalTypeMenu.selectionAction = { index, item  in
            self.assignedPurposalTypeButton.setTitle("\(self.assignedPurposalTypeMenu.selectedItem ?? "")", for: .normal)
            self.workoutContentAPTypes?.append(self.assignedPurposalTypeMenu.selectedItem ?? "")
        }
    }
    
    @objc func handleSetWorkoutImage() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    @objc func saveFood() {
        guard let title = workoutNameLabel.text else { return }
        guard let workoutContentType = workoutTypeButton.titleLabel!.text else { return }
        guard let equipments = equipmentLabel.text else { return }
        guard let description = descriptionLabel.text else { return }
        guard let instructionVideoUrl = recipeVideoUrl.text else { return }
        guard let assignedPurposalTypes = workoutContentAPTypes?.compactMap({ $0 }) else { return }
        guard let image = workoutImage.image else { return }
        Service.uploadImage(image: image) { (imageUrl) in
            let credentials = WorkoutContentCredentials.init(title: title, workoutContentType: workoutContentType, assignedPurposalType: assignedPurposalTypes, equipments: equipments, description: description, imageUrl: imageUrl, instructionVideoUrl: instructionVideoUrl, instructionDuration: "")
            
            Service.uploadWorkoutContent(credentials: credentials) { (err, ref) in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
        }
        
        delegate?.saveWorkoutInfo(self)
    }
    
    
    // MARK: - Helpers

}
