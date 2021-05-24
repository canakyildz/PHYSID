//
//  FeedContentHeader.swift
//  PHYSID
//
//  Created by Apple on 20.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol FeedContentHeaderDelegate: class {
    func handleUsernameTapped(_ cell: FeedContentHeader)
    func handleLikeTapped(_ cell: FeedContentHeader)
    func handleReloadingThroughCommenting(_ cell: FeedContentHeader, message: String)
    func handleOptionsTapped(_ cell: FeedContentHeader)
    
}

class FeedContentHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: FeedContentHeaderDelegate?
    
    var post: Post? {
        didSet { configure() }
    }
    
    var currentUser: User?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let commentaryProfileImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var commentField: customInputAccessoryView = {
        let civ = customInputAccessoryView()
        civ.delegate = self
        civ.messageInputTextView.isScrollEnabled = true
        civ.layer.shadowOffset = CGSize(width: 0.1, height: 0.5)
        civ.layer.shadowOpacity = 0.15
        civ.layer.shadowColor = UIColor.black.cgColor
        civ.layer.shadowRadius = 2.7
        civ.backgroundColor = .white
        civ.sendButton.setTitle("Submit", for: .normal)
        civ.placeholderLabel.text = "Leave a comment"
        return civ
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Can Akyıldız", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Bold", size: 12)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var professionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Personal Trainer, Conditioner", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Light", size: 12)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icson").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleOptionsTapped), for: .touchUpInside)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    lazy var postImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray        
        return iv
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "iwontsayagain"),for: .normal)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1.5
        button.layer.shadowOpacity = 0
        button.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-topic-24"),for: .normal)
        button.setDimensions(height: 23, width: 24)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        return button
    }()
    
    let savePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-bookmark-24"),for: .normal)
        button.setDimensions(height: 26, width: 26)
        button.tintColor = #colorLiteral(red: 0.03138880076, green: 0.03138880076, blue: 0.03138880076, alpha: 1)
        button.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        return button
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Light", size: 12)
        label.text = " 3 likes"
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        return label
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.customFont(name: "Helvetica Light", size: 12)
        label.text = " 10 comments"
        return label
    }()
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:        label.font = UIFont.customFont(name: "Helvetica", size: 12)
])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .regular)]))
        label.attributedText = attributedText
        return label
    }()
    
    let imageryCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 12)
])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5, weight: .regular)]))
        label.attributedText = attributedText
        return label
    }()
    
    
    let imageryTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.backgroundColor = .white
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13.5)])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.5, weight: .semibold)]))
        label.attributedText = attributedText
        return label
    }()
    
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "2 DAYS AGO"
        return label
    }()
    
    
    private lazy var imageryVV = UIView()
    
    
    
    // MARK: - Lifecycle
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchCurrentUser()
        
        backgroundColor = #colorLiteral(red: 0.9703759518, green: 0.9703759518, blue: 0.9703759518, alpha: 1)
        
        let mv = UIView()
        addSubview(mv)
        mv.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 4,paddingLeft: 20, paddingBottom: 74, paddingRight: 20)
        mv.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        mv.layer.shadowOpacity = 0.3
        mv.layer.shadowRadius = 2.7
        mv.layer.shadowColor = UIColor.black.cgColor
        mv.layer.cornerRadius = 10
        mv.backgroundColor = .white
        
        
        let pv = UIView()
        addSubview(pv)
        pv.anchor(top: mv.topAnchor ,left: mv.leftAnchor, paddingTop: 17, paddingLeft: 22, width: 35, height: 35)
        pv.addSubview(profileImageView)
        profileImageView.anchor(top: pv.topAnchor,left: pv.leftAnchor,bottom: pv.bottomAnchor,right: pv.rightAnchor)
        pv.layer.cornerRadius = 7
        profileImageView.layer.cornerRadius = 7
        pv.layer.shadowOffset = CGSize(width: 1, height: 2)
        pv.layer.shadowOpacity = 0.5
        pv.layer.shadowColor = postImageView.image?.areaAverage().cgColor
        
        
        let stack = UIStackView(arrangedSubviews: [usernameButton, professionButton])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = -3
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor,left: profileImageView.rightAnchor,bottom: profileImageView.bottomAnchor,right: mv.rightAnchor ,paddingLeft: 8,paddingRight: 30, height: 35)
        stack.centerY(inView: profileImageView)
        
        
        //imagery
        imageryVV.isHidden = true
        postImageView.isHidden = true
        imageryTitleLabel.isHidden = true
        
        
        mv.addSubview(imageryVV)
        imageryVV.anchor(top: mv.topAnchor, paddingTop: 70, width: frame.width - 65, height: frame.width - 110)
        imageryVV.centerX(inView: self)
        imageryVV.layer.cornerRadius = 10
        imageryVV.addSubview(postImageView)
        postImageView.fillSuperview()
        postImageView.layer.cornerRadius = 10
        imageryVV.layer.shadowOffset = CGSize(width: 0.5, height: 5)
        imageryVV.layer.shadowOpacity = 0.7
        imageryVV.layer.shadowColor = postImageView.image?.areaAverage().cgColor
        
        addSubview(imageryTitleLabel)
        imageryTitleLabel.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 14, paddingLeft: 8, paddingRight: 8, height: 35)
        
        captionLabel.isHidden = true
        let buttonStack = UIStackView(arrangedSubviews: [likeButton,likesLabel, UIView(), commentButton,commentsLabel])
        
        buttonStack.distribution = .fillProportionally
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        addSubview(buttonStack)
        buttonStack.anchor(left: profileImageView.leftAnchor ,bottom: mv.bottomAnchor, paddingLeft: 6, paddingBottom: 16, width: 200, height: 30)
        
        addSubview(savePostButton)
        savePostButton.anchor(top: buttonStack.topAnchor,bottom: buttonStack.bottomAnchor, right: mv.rightAnchor, paddingRight: 20)
        
        imageryCaptionLabel.isHidden = true
        addSubview(imageryCaptionLabel)
        imageryCaptionLabel.anchor(top: imageryTitleLabel.bottomAnchor, left: imageryTitleLabel.leftAnchor,bottom: buttonStack.topAnchor, right: postImageView.rightAnchor, paddingBottom: 10)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: profileImageView.bottomAnchor,left: mv.leftAnchor ,bottom: buttonStack.topAnchor, right: mv.rightAnchor, paddingTop: 10, paddingLeft: 22, paddingBottom: 10, paddingRight: 22)
        captionLabel.centerX(inView: self)
        
        
        addSubview(commentaryProfileImage)
        bringSubviewToFront(commentaryProfileImage)
        commentaryProfileImage.anchor(left: mv.leftAnchor, bottom: bottomAnchor, paddingLeft: 9, paddingBottom: 10, width: 40, height: 40)
        commentaryProfileImage.layer.cornerRadius = 8
        backgroundColor = #colorLiteral(red: 0.9722993338, green: 0.9722993338, blue: 0.9722993338, alpha: 1)
        
        addSubview(commentField)
        bringSubviewToFront(commentField)
        commentField.layer.cornerRadius = 8
        commentField.anchor(left: commentaryProfileImage.rightAnchor,bottom: bottomAnchor, right: mv.rightAnchor,paddingLeft: 5 ,height: 50)
        
        
        if self.post?.ownerUid == currentUser?.uid {
            
            self.addSubview(self.optionsButton)
            self.bringSubviewToFront(self.optionsButton)
            self.optionsButton.anchor(right: mv.rightAnchor,paddingRight: 22)
            self.optionsButton.setDimensions(height: 24, width: 24)
            self.optionsButton.centerY(inView: pv)
            
            self.optionsButton.isEnabled = true
            self.optionsButton.isHidden = false
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(self)
    }
    
    @objc func handleOptionsTapped() {
        
        Service.removePost(post: post!, completion: { (err, ref) in
            if let err = err {
                print(err.localizedDescription)
            }
        })
        self.delegate?.handleOptionsTapped(self)
        
    }
    
    @objc func handleLikeTapped(){
        delegate?.handleLikeTapped(self)
    }
    
    
    @objc func handleSubscribe() {
        //        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
        //        delegate?.handleShowLikes(for: self)
    }
    
    // MARK: - Helpers
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: currentUid) { (user) in
            self.currentUser = user
        }
        
    }
    
    func configure() {
        guard let post = self.post else { return }
        guard let url = post.user.profileImageUrl else { return }
        guard let currentUser = self.currentUser else { return }
        guard let currentUrl = currentUser.profileImageUrl else { return }
        self.commentaryProfileImage.sd_setImage(with: URL(string: currentUrl))
        
        
        REF_COMMENTS.child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            let comments = snapshot.children.allObjects.count
            self.commentsLabel.text = " \(comments) comments"
            
        }
        
        REF_POST_LIKES.child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            let likes = snapshot.children.allObjects.count
            self.likesLabel.text = " \(likes) likes "
        }
        
        if !post.didLike {
            self.likeButton.setImage(#imageLiteral(resourceName: "iwontsayagain"), for: .normal)
        } else {
            self.likeButton.setImage(#imageLiteral(resourceName: "imfinnagogetit"), for: .normal)
        }
        
        profileImageView.sd_setImage(with: URL(string: url))
        usernameButton.setTitle(post.user.name, for: .normal)
        professionButton.setTitle(post.user.professionType, for: .normal)
        
        
        if post.isSay == true {
            
            imageryVV.isHidden = true
            postImageView.isHidden = true
            imageryTitleLabel.isHidden = true
            imageryCaptionLabel.isHidden = true
            captionLabel.isHidden = false
            captionLabel.text = post.caption
            
        } else {
            
            captionLabel.isHidden = true
            imageryCaptionLabel.isHidden = false
            imageryVV.isHidden = false
            postImageView.isHidden = false
            imageryTitleLabel.isHidden = false
            guard let postImageUrl = post.postImageUrl else { return }
            imageryTitleLabel.text = post.title
            imageryCaptionLabel.text = post.caption
            postImageView.sd_setImage(with: URL(string: postImageUrl))
            
        }
    }
}

extension FeedContentHeader: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: customInputAccessoryView, wantsToSend message: String) {
        delegate?.handleReloadingThroughCommenting(self, message: message)
        guard let post = post else { return }
        REF_COMMENTS.child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            let comments = snapshot.children.allObjects.count
            self.commentsLabel.text = " \(comments) comments"
            
        }
        
        inputView.clearMessageText()
        
    }}



