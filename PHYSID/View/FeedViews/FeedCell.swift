//
//  FeedCell.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol FeedCellDelegate: class {
    func handleUsernameTapped(_ cell: FeedCell)
    func handleLikeTapped(_ cell: FeedCell)
    
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: FeedCellDelegate?
    var post: Post? {
        didSet { configure() }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Can Akyıldız", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Bold", size: 12.5)
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
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.customFont(name: "Helvetica", size: 12)])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 12.5)]))
        label.attributedText = attributedText
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.backgroundColor = .white
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.customFont(name: "Helvetica Bold", size: 14)
        ])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Bold", size: 13.5)]))
        label.attributedText = attributedText
        return label
    }()
    
    let imageryTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.backgroundColor = .white
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13.5)])
        attributedText.append(NSAttributedString(string: "What's good everyone? I'm on the way to build this beautiful application.", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Bold", size: 13.5)]))
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
    lazy var buttonStack = UIStackView(arrangedSubviews: [likeButton,likesLabel, UIView(), commentButton,commentsLabel])
    lazy var mv = UIView()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mv)
        mv.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 4, paddingBottom: 4)
        mv.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        mv.layer.shadowOpacity = 0.55
        mv.layer.shadowColor = UIColor.black.cgColor
        mv.layer.cornerRadius = 20
        mv.layer.shadowRadius = 2

        mv.backgroundColor = .white
        
        
        let pv = UIView()
        addSubview(pv)
        pv.anchor(top: mv.topAnchor ,left: mv.leftAnchor, paddingTop: 17, paddingLeft: 22, width: 35, height: 35)
        pv.addSubview(profileImageView)
        profileImageView.anchor(top: pv.topAnchor,left: pv.leftAnchor,bottom: pv.bottomAnchor,right: pv.rightAnchor)
        pv.layer.cornerRadius = 7
        profileImageView.layer.cornerRadius = 7
        pv.layer.shadowOffset = CGSize(width: 1, height: 2)
        pv.layer.shadowOpacity = 0.7
        pv.layer.shadowRadius = 2.5
        pv.layer.shadowColor = postImageView.image?.areaAverage().cgColor
        
        
        let stack = UIStackView(arrangedSubviews: [usernameButton, professionButton])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = -3
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor,left: profileImageView.rightAnchor,bottom: profileImageView.bottomAnchor,right: mv.rightAnchor ,paddingLeft: 8,paddingRight: 30, height: 35)
        stack.centerY(inView: profileImageView)
        
        
        imageryVV.isHidden = true
        postImageView.isHidden = true
        imageryTitleLabel.isHidden = true
        
        
        
        
        titleLabel.isHidden = true
        captionLabel.isHidden = true
        
        buttonStack.distribution = .fillProportionally
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        addSubview(buttonStack)
        buttonStack.anchor(left: profileImageView.leftAnchor ,bottom: mv.bottomAnchor, paddingLeft: 6, paddingBottom: 16, width: 200, height: 30)
        
        addSubview(savePostButton)
        savePostButton.anchor(top: buttonStack.topAnchor,bottom: buttonStack.bottomAnchor, right: mv.rightAnchor, paddingRight: 20)
        
        
    }
    
    // MARK: - Selectors
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(self)
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
    
    func configure() {
        guard let post = post else { return }
        
        guard let url = post.user.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: url))
        
        REF_COMMENTS.child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            let commentcount = snapshot.children.allObjects.count
            self.commentsLabel.text = " \(commentcount) comments"
        }
        
        usernameButton.setTitle(post.user.name, for: .normal)
        professionButton.setTitle(post.user.professionType, for: .normal)
        
        REF_POST_LIKES.child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            let likes = snapshot.children.allObjects.count
            self.likesLabel.text = " \(likes) likes "
        }
        
        if !post.didLike {
            self.likeButton.setImage(#imageLiteral(resourceName: "iwontsayagain"), for: .normal)
        } else {
            self.likeButton.setImage(#imageLiteral(resourceName: "imfinnagogetit"), for: .normal)
        }
        if post.isSay == true {
            
            imageryVV.isHidden = true
            imageryVV.removeFromSuperview()
            postImageView.isHidden = true
            postImageView.removeFromSuperview()
            imageryTitleLabel.removeFromSuperview()
            
            imageryTitleLabel.isHidden = true
            captionLabel.isHidden = false
            addSubview(captionLabel)
            captionLabel.anchor(top: profileImageView.bottomAnchor,bottom: buttonStack.topAnchor, paddingTop: 8,paddingBottom: 10, width: frame.width - 45)
            captionLabel.centerX(inView: self)
            
            captionLabel.text = post.caption
            
        } else {
            
            captionLabel.isHidden = true
            captionLabel.removeFromSuperview()
            
            imageryVV.isHidden = false
            postImageView.isHidden = false
            mv.addSubview(imageryVV)
            imageryVV.anchor(top: mv.topAnchor, paddingTop: 70, width: frame.width - 45, height: frame.width - 90)
            imageryVV.centerX(inView: self)
            imageryVV.layer.cornerRadius = 10
            imageryVV.addSubview(postImageView)
            postImageView.fillSuperview()
            postImageView.layer.cornerRadius = 10
            imageryVV.layer.shadowOffset = CGSize(width: 0.7, height: 3)
            imageryVV.layer.shadowOpacity = 0.7
            imageryVV.layer.shadowRadius = 2

            imageryVV.layer.shadowColor = postImageView.image?.areaAverage().cgColor
            
            
            imageryTitleLabel.isHidden = false
            addSubview(imageryTitleLabel)
            imageryTitleLabel.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 14, paddingLeft: 8, paddingRight: 8)
            imageryTitleLabel.backgroundColor = .white
            
            guard let postImageUrl = post.postImageUrl else { return }
            imageryTitleLabel.text = post.title
            postImageView.sd_setImage(with: URL(string: postImageUrl))
            
        }
    }
}
