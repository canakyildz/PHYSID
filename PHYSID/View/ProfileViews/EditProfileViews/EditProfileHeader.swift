//
//  EditProfileHeader.swift
//  PHYSID
//
//  Created by Apple on 25.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
    func didTapChangeBackPhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile Image", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    
    let bigView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "32131"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let bigViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Background Image", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.addTarget(self, action: #selector(handleChangeBackPhoto), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(bigView)
        bigView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 250)
        addSubview(profileImageView)
        profileImageView.anchor(top: bigView.bottomAnchor,left: bigView.leftAnchor, paddingTop: -60,paddingLeft: 20, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        
        addSubview(bigViewButton)
        bigViewButton.anchor(top: bigView.topAnchor, left: bigView.leftAnchor, bottom: bigView.bottomAnchor, right: bigView.rightAnchor)
        
        addSubview(profileButton)
        profileButton.anchor(top: profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor)
        profileButton.layer.cornerRadius = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selector
    
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    @objc func handleChangeBackPhoto() {
        delegate?.didTapChangeBackPhoto()
    }
    
    
    func configure() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            guard let profileImageUrl = user.profileImageUrl else { return }
            self.profileImageView.sd_setImage(with: URL(string: profileImageUrl))
            
            
            guard let backgroundImageUrl = user.backgroundImageUrl else { return }
            self.bigView.sd_setImage(with: URL(string: backgroundImageUrl)) }
    }
}

