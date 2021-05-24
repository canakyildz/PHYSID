//
//  ExploreCell.swift
//  PHYSID
//
//  Created by Apple on 18.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    // MARK: - Properties
        
    var post: Post? {
        didSet { configure() }
    }
    
    let postsView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Men's GYM Fitness Clothing simple"))
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    let imageryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "New day new things, you know the vibes!!!!! Don't you play with the gang cuuuz"
        label.lineBreakMode = .byClipping
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 11)
        label.numberOfLines = 2
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Can Akyıldız", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Bold", size: 12)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.isHidden = true
        return iv
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.customFont(name: "Helvetica", size: 12)])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 13)]))
        label.attributedText = attributedText
        label.isHidden = true
        return label
    }()
    
    private lazy var imageryVV = UIView()
    
    private lazy var mv = UIView()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .clear
        
        addSubview(mv)
        mv.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 4 ,paddingLeft: 2, paddingBottom: 4,paddingRight: 2)
        mv.layer.shadowOffset = CGSize(width: 0.6, height: 1)
        mv.layer.shadowOpacity = 0.5
        mv.layer.shadowColor = UIColor.black.cgColor
        mv.layer.cornerRadius = 7
        mv.layer.shadowRadius = 2
        mv.backgroundColor = .clear
        
        mv.addSubview(postsView)
        postsView.layer.cornerRadius = 7
        postsView.anchor(top: mv.topAnchor, left: mv.leftAnchor, bottom: mv.bottomAnchor, right: mv.rightAnchor, paddingBottom: 30)
        

        addSubview(imageryTitleLabel)
        bringSubviewToFront(imageryTitleLabel)
        imageryTitleLabel.anchor(top: postsView.bottomAnchor, left: postsView.leftAnchor,bottom: bottomAnchor, right: postsView.rightAnchor,paddingTop: 3, paddingLeft: 5,paddingRight: 3)
        mv.addSubview(profileImageView)
        profileImageView.anchor(top: mv.topAnchor, left: mv.leftAnchor, paddingTop: 4, paddingLeft: 4, width: 35, height: 35)
        
        mv.addSubview(usernameButton)
        usernameButton.anchor(left: profileImageView.rightAnchor, paddingLeft: 4)
        usernameButton.centerY(inView: profileImageView)
        
        profileImageView.layer.cornerRadius = 35 / 3.5
        
        mv.addSubview(captionLabel)
        captionLabel.anchor(top: profileImageView.bottomAnchor,left: mv.leftAnchor , bottom: mv.bottomAnchor, right: mv.rightAnchor, paddingTop: 5, paddingLeft: 5,paddingBottom: 0, paddingRight: 5)
        
    }
    
    func configure() {
        guard let post = post else { return }
        
        if post.isSay == true {
            
            postsView.isHidden = true
            usernameButton.isHidden = false
            imageryTitleLabel.isHidden = true
            captionLabel.isHidden = false
            profileImageView.isHidden = false
            
            mv.backgroundColor = .white
            
            guard let url = post.user.profileImageUrl else { return }
            profileImageView.sd_setImage(with: URL(string: url))
            usernameButton.setTitle(post.user.name, for: .normal)
            captionLabel.text = post.caption
            
        } else {
            
            captionLabel.isHidden = true
            postsView.isHidden = false
            usernameButton.isHidden = true
            profileImageView.isHidden = true
            imageryTitleLabel.isHidden = false
            mv.backgroundColor = .clear

            guard let postImageUrl = post.postImageUrl else { return }
            postsView.sd_setImage(with: URL(string: postImageUrl))
            imageryTitleLabel.text = post.title
            postsView.sd_setImage(with: URL(string: postImageUrl))
            
        }
        
    }
    
}
