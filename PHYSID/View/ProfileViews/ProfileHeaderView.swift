//
//  ProfileHeaderView.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileHeaderViewDelegate: class {
    func handleShowEditProfile()
    func follow(_ header: ProfileHeaderView)
    func startChatting(_ header: ProfileHeaderView, wantsToChatwith user: User)
}

class ProfileHeaderView: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    weak var delegate: ProfileHeaderViewDelegate?
    var user: User? {
        didSet { configureProfileData() }
    }
    var viewModel: ProfileViewModel?
    
    let bigView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 24)
        label.textColor = .black
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-map-pin-24"))
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.customFont(name: "Helvetica", size: 14)
        label.addSubview(iv)
        iv.anchor(right: label.leftAnchor,paddingRight: 3)
        iv.setDimensions(height: 16, width: 18)
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 2.4
        iv.layer.borderColor = #colorLiteral(red: 0.9519947652, green: 0.9519947652, blue: 0.9519947652, alpha: 1)
        return iv
    }()
    
    let professionLabel: UILabel = {
        let label = UILabel()
        let iv = UIImageView(image: #imageLiteral(resourceName: "persola"))
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.customFont(name: "Helvetica", size: 14)
        label.addSubview(iv)
        iv.anchor(right: label.leftAnchor,paddingRight: 3)
        iv.setDimensions(height: 16, width: 18)
        return label
    }()
    
    
    let bio: UILabel = {
        let label = UILabel()
        label.textColor = . darkGray
        label.text = ""
        label.numberOfLines = 30
        label.textAlignment = .center
        label.font = UIFont.customFont(name: "Helvetica", size: 13)
        return label
    }()
    
    let SubscibersLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Followers"
        descriptiveLabel.textAlignment = .center
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 10)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, paddingTop: 1)
        descriptiveLabel.centerX(inView: label)
        return label
    }()
    
    let physidOnlySubsLabel: UILabel = {
        let label = UILabel()
        label.text = "64"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        let descriptiveLabel = UILabel()
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.textAlignment = .center
        descriptiveLabel.text = "Paid Followers"
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 10)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, paddingTop: 1)
        descriptiveLabel.centerX(inView: label)
        return label
    }()
    
    let physidOnlyContentsLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Paid Content"
        descriptiveLabel.numberOfLines = 2
        descriptiveLabel.textAlignment = .center
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 10)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, paddingTop: 1)
        descriptiveLabel.centerX(inView: label)
        return label
    }()
    
    let contentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 20)
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Contents"
        descriptiveLabel.textAlignment = .center
        descriptiveLabel.font = UIFont.customFont(name: "Helvetica Light", size: 10)
        label.addSubview(descriptiveLabel)
        descriptiveLabel.anchor(top: label.bottomAnchor, paddingTop: 1)
        descriptiveLabel.centerX(inView: label)
        return label
    }()
    
    let blogPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "Blog Posts"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica", size: 14)
        button.tintColor = .black
        button.titleLabel?.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let subscriptiveImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "betonmyself").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.setDimensions(height: 26, width: 26)
        image.isHidden = true
        return image
    }()
    
    let messageButtonImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icons8-new-message-48-3").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.setDimensions(height: 26, width: 26)
        image.isHidden = true
        return image
    }()
    
    lazy var followButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Folow"
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Light", size: 13)
        return label
    }()
    
    
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Message", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica", size: 14)
        button.tintColor = .black
        button.titleLabel?.backgroundColor = .white
        button.titleLabel?.setDimensions(height: 20, width: 63)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-edit-24").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: #selector(handleShowEditProfile), for: .touchUpInside)
        return button
    }()
    
    
    
    private let secondLine = UnderLineView()
    private let thirdLine = UnderLineView()
    private let fifthLine = UnderLineView()
    
    private let av = UIView()

    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        av.anchor(top: bigView.bottomAnchor, left: bigView.leftAnchor, paddingTop: -30, width: frame.width, height: 60)
        av.backgroundColor = .white
        av.layer.cornerRadius = 30
        
        addSubview(profileImageView)
        profileImageView.anchor(top: bigView.bottomAnchor,paddingTop: -55, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        profileImageView.centerX(inView: bigView)

        
        let stack = UIStackView(arrangedSubviews: [contentCountLabel,physidOnlyContentsLabel, physidOnlySubsLabel ,SubscibersLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.setDimensions(height: 50, width: frame.width / 1.75)
        addSubview(stack)
        stack.alignment = .center
        
        let informativeStack = UIStackView(arrangedSubviews: [nameLabel,professionLabel, locationLabel ,bio, stack])
        informativeStack.axis = .vertical
        informativeStack.distribution = .equalSpacing
        informativeStack.spacing = 8
        addSubview(informativeStack)
        informativeStack.alignment = .center
        informativeStack.centerX(inView: profileImageView)
        informativeStack.anchor(top: profileImageView.bottomAnchor, paddingTop: 12, width: frame.width / 1.75)
        bio.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 30, paddingRight: 30)

        informativeStack.centerX(inView: profileImageView)
        
        
        
//        addSubview(thirdLine)
//        thirdLine.anchor(top: informativeStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32,paddingLeft: 15,paddingRight: 25, height: 0.5)
    
        addSubview(subscriptiveImage)
        subscriptiveImage.anchor(top: av.topAnchor, left: profileImageView.rightAnchor,paddingTop: 6, paddingLeft: 10, width: 30, height: 30)
        
        addSubview(messageButtonImage)
        messageButtonImage.anchor(top: subscriptiveImage.bottomAnchor,right: subscriptiveImage.rightAnchor, paddingRight: 0, width: 30, height: 30)
        
        addSubview(subscribeButton)
        
        
        addSubview(messageButton)
        messageButton.anchor(top: subscribeButton.bottomAnchor,left: messageButtonImage.rightAnchor,paddingTop: -1,paddingRight: 1, width: 63, height: 28)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(left: nameLabel.rightAnchor,bottom: nameLabel.bottomAnchor, paddingLeft: 6, paddingBottom: 3.2)
        
        
    }
    
    // MARK: - Selectors
    
    @objc func handleChat() {
        guard let user = user else { return }
        delegate?.startChatting(self, wantsToChatwith: user)
    }
    
    @objc func handleSubscribe() {
        delegate?.follow(self)
        guard let user = user else { return }
        if !user.isFollowed {
            subscribeButton.setTitle("Following", for: .normal)
            subscribeButton.removeFromSuperview()
            addSubview(subscribeButton)
            subscribeButton.anchor(top: av.topAnchor, left: subscriptiveImage.rightAnchor,paddingTop: 6, paddingRight: 4, width: 63, height: 28)
            messageButton.anchor(top: subscribeButton.bottomAnchor,left: messageButtonImage.rightAnchor,paddingTop: -1,paddingRight: 1, width: 63, height: 28)

        } else {
            subscribeButton.setTitle("Follow", for: .normal)
            subscribeButton.removeFromSuperview()
            addSubview(subscribeButton)
            subscribeButton.anchor(top: av.topAnchor, left: subscriptiveImage.rightAnchor,paddingTop: 6, paddingRight: -6, width: 63, height: 28)
            messageButton.anchor(top: subscribeButton.bottomAnchor,left: messageButtonImage.rightAnchor,paddingTop: -1,paddingRight: 1, width: 63, height: 28)


        }
        
    }
    
    @objc func handleShowEditProfile() {
        delegate?.handleShowEditProfile()
    }
    
    
    // MARK: - Helpers
    
    
    func configureProfileData() {
        guard let user = self.user else { return }
        REF_USER_POSTS.child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let postCount = snapshot.count
            
            self.contentCountLabel.text = "\(postCount)"
            
        }
        let viewModel = ProfileViewModel(user: user)
        self.nameLabel.text = viewModel.name
        self.professionLabel.text = viewModel.professionType
        self.locationLabel.text = viewModel.location
        self.bio.text = viewModel.bio
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        self.bigView.sd_setImage(with: viewModel.backgroundImageUrl)
        self.SubscibersLabel.text = "\(user.stats?.followers ?? 0)"
        if !user.isCurrentUser {
            self.editProfileButton.isHidden = true
            self.subscribeButton.isHidden = false
            self.messageButton.isHidden = false
            self.subscriptiveImage.isHidden = false
            self.messageButtonImage.isHidden = false

            
        }
        
        if !user.isFollowed {
            subscribeButton.setTitle("Follow", for: .normal)
            subscriptiveImage.image = #imageLiteral(resourceName: "betonmyself")
            subscribeButton.anchor(top: av.topAnchor, left: subscriptiveImage.rightAnchor,paddingTop: 6, paddingRight: -6, width: 63, height: 28)


            
        } else {
            subscribeButton.setTitle("Following", for: .normal)
            subscriptiveImage.image = #imageLiteral(resourceName: "followeddcuzzz")
            subscribeButton.anchor(top: av.topAnchor, left: subscriptiveImage.rightAnchor,paddingTop: 6, paddingRight: 4, width: 63, height: 28)

        }
        
    }
}




