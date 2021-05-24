//
//  WorkoutContentEditorHeaderView.swift
//  PHYSID
//
//  Created by Apple on 2.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import DropDown

protocol WorkoutContentEditorHeaderViewDelegate: class {
    func updateContentInfo(_ cell: WorkoutContentEditorHeaderView)
    func didTapChangeProfilePhoto()
    
}

class WorkoutContentEditorHeaderView: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    weak var delegate: WorkoutContentEditorHeaderViewDelegate?
    private var workoutContentAPTypes: [String]? = [String]()
    var workoutContent: WorkoutContent! {
        didSet { configureHolders() }
    }
    
    lazy var updateContentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(updateContent), for: .touchUpInside)
        return button
    }()
    
    let contentImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "veg"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let contentImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.addTarget(self, action: #selector(handleSetContentImage), for: .touchUpInside)
        return button
    }()
    
    let contentNameLabel: UITextField = {
        let label = UITextField()
        label.placeholder = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let contentTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Full body", "Shoulders", "Arms", "Back", "Abs", "Legs", "Chest", "Cardio"]
        menu.direction = .bottom
        return menu
    }()
    
    private let contentTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitle("", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(showContentTypeDrop), for: .touchUpInside)
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
    
    let instructorVideoUrl: UITextField = {
        let label = UITextField()
        label.placeholder = ""
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
        
        addSubview(contentImage)
        contentImage.anchor(top: topAnchor, left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, paddingBottom: 700)
        
        addSubview(updateContentButton)
        updateContentButton.anchor(top: contentImage.bottomAnchor, right: contentImage.rightAnchor, width: 70, height: 30)
        
        addSubview(contentImageButton)
        contentImageButton.anchor(top: contentImage.topAnchor, left: contentImage.leftAnchor, bottom: contentImage.bottomAnchor, right: contentImage.rightAnchor)
        contentImageButton.layer.cornerRadius = 50
        
        addSubview(contentNameLabel)
        contentNameLabel.anchor(top: contentImage.bottomAnchor, paddingTop: 20)
        contentNameLabel.centerX(inView: self)
        
        contentTypeMenu.anchorView = contentTypeButton
        
        
        addSubview(contentTypeButton)
        contentTypeButton.anchor(top: contentNameLabel.bottomAnchor, paddingTop: 8, height: 40)
        contentTypeButton.centerX(inView: contentNameLabel)
        
        assignedPurposalTypeMenu.anchorView = assignedPurposalTypeButton
        
        addSubview(assignedPurposalTypeButton)
        assignedPurposalTypeButton.anchor(top: contentTypeButton.bottomAnchor, paddingTop: 8, height: 40)
        assignedPurposalTypeButton.centerX(inView: contentTypeButton)
        
        
        
        
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
        (instructionLabel).anchor(top: thirdLine.bottomAnchor, paddingTop: 16)
        (instructionLabel).centerX(inView: thirdLine)
        
        addSubview(instructorVideoUrl)
        instructorVideoUrl.anchor(top: (instructionLabel).bottomAnchor,left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 15, paddingLeft: 4, paddingRight: 4)
        instructorVideoUrl.centerX(inView: self)
        
        addSubview(fourthLine)
        fourthLine.anchor(top: instructorVideoUrl.bottomAnchor, left: thirdLine.leftAnchor, right: thirdLine.rightAnchor, paddingTop: 20, height: 0.3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func showContentTypeDrop() {
        contentTypeMenu.show()
        contentTypeMenu.selectionAction = { index, item  in
            self.contentTypeButton.setTitle("\(self.contentTypeMenu.selectedItem ?? "")", for: .normal)
        }
    }
    
    @objc func showAPTypeDrop() {
        assignedPurposalTypeMenu.show()
        assignedPurposalTypeMenu.selectionAction = { index, item  in
            self.assignedPurposalTypeButton.setTitle("\(self.assignedPurposalTypeMenu.selectedItem ?? "")", for: .normal)
            self.workoutContent.assignedPurposalType.append(self.assignedPurposalTypeMenu.selectedItem ?? "")
            print(self.workoutContent.assignedPurposalType)
            print(self.assignedPurposalTypeButton.titleLabel?.text ?? "")

        }
    }
    
    
    @objc func handleSetContentImage() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    @objc func updateContent() {
        guard let contentName = contentNameLabel.text else { return }
        guard let contentType = contentTypeButton.titleLabel?.text else { return }
        guard let assignedPurposalTypes = workoutContent?.assignedPurposalType.compactMap({ $0 }) else { return }
        guard let equipmentLabel = equipmentLabel.text else { return }
        guard let videoUrl = instructorVideoUrl.text else { return }
        guard let description = descriptionLabel.text else { return }
        
        self.workoutContent.title = contentName
        self.workoutContent.workoutContenttype = contentType
        self.workoutContent.equipments = equipmentLabel
        self.workoutContent.assignedPurposalType = assignedPurposalTypes
        self.workoutContent.instructionVideoUrl = videoUrl
        self.workoutContent.description = description
        
        Service.saveWorkoutContentData(workoutContent: workoutContent) { (err, ref) in
            
        }
        delegate?.updateContentInfo(self)
    }
    
    // MARK: - Helpers
    
    func configureHolders() {
        contentNameLabel.text =  workoutContent.title
        contentTypeButton.setTitle(workoutContent.workoutContenttype, for: .normal)
        assignedPurposalTypeButton.setTitle(workoutContent.assignedPurposalType.first, for: .normal)
        equipmentLabel.text = workoutContent.equipments
        instructorVideoUrl.text = workoutContent.instructionVideoUrl
        descriptionLabel.text = workoutContent.description
        contentImage.sd_setImage(with: URL(string: workoutContent.imageUrl!))
        
        
        
    }
}
