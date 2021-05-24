//
//  WorkoutCell.swift
//  PHYSID
//
//  Created by Apple on 17.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var workoutContent: WorkoutContent? {
        didSet { configure() }
    }
    
    let videoThumbView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Ekran Resmi 2019-12-01 20.56.32"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let adderView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "navigationbarlogo"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit // temporary
        iv.setDimensions(height: 34, width: 28)
        iv.backgroundColor = .black
        return iv
    }()
    
    let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Interval Cardio"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let trainingTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Full body training"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let equipmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Equipment required: No"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let line = UnderLineView()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    
    func configureUI() {
        selectionStyle = .none

     
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 1, height: 2)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.setDimensions(height: 80, width: 80)
        vv.anchor(left: leftAnchor, paddingLeft: 12)
        vv.centerY(inView: self)
        vv.addSubview(videoThumbView)
        videoThumbView.layer.cornerRadius = 5
        videoThumbView.setDimensions(height: 80, width: 80)
        videoThumbView.anchor(top: topAnchor, paddingTop: 15)
        videoThumbView.centerX(inView: vv)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, trainingTypeLabel, equipmentLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(left: videoThumbView.rightAnchor,right: rightAnchor, paddingLeft: 6, paddingRight: 6)
        stack.centerY(inView: videoThumbView)
    

        addSubview(line)
        line.anchor(top: vv.bottomAnchor, left: vv.leftAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 5,paddingRight: 10, height: 0.2)
        
    }
    
    func configure() {
        guard let workoutContent = workoutContent else { return }
        guard let imageUrl = workoutContent.imageUrl else { return }
        guard let workoutImageUrl = URL(string: imageUrl) else { return }
        videoThumbView.sd_setImage(with: workoutImageUrl)
        titleLabel.text = workoutContent.title
        trainingTypeLabel.text = workoutContent.workoutContenttype
        equipmentLabel.text = workoutContent.equipments
        // put these in a view model later on
        
        print(workoutContent.title)
    }
    
}
