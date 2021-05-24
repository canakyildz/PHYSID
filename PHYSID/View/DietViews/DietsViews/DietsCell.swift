//
//  DietsCel.swift
//  PHYSID
//
//  Created by Apple on 8.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class DietsCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var diet: Diet? {
        didSet {
            configure() }
    }
    
    let userProfileImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        return iv
    }()
    
    let dietDefinitiveImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        return iv
    }()
    
    
    let firstFoodImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Ekran Resmi 2020-08-22 23.21.48"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    lazy var professionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Personal Trainer, Conditioner", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.titleLabel?.font = UIFont.customFont(name: "Helvetica Light", size: 12)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    let secondFoodImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "paleocell"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    let defImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lastoneiguess").withTintColor(.lightGray))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    lazy var userNameLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Can Akyıldız", for: .normal)
        button.setTitleColor(.black, for: .normal)
        let customFont = UIFont(name: "Helvetica Bold", size: 13)
        button.titleLabel?.font = customFont
        
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        
        return button
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
    
    let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "betonmyself"),for: .normal)
        button.setDimensions(height: 24, width: 26)
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
        let customFont = UIFont(name: "Helvetica", size: 12)
        label.font = customFont
        label.text = " 3 likes"
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let customFont = UIFont(name: "Helvetica Bold", size: 14)
        label.textColor = #colorLiteral(red: 0.1628331218, green: 0.1628331218, blue: 0.1628331218, alpha: 1)
        label.adjustsFontForContentSizeCategory = true
        label.backgroundColor = .white
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:        label.font = UIFont.customFont(name: "Helvetica Bold", size: 14)
        ])
        attributedText.append(NSAttributedString(string: "The most efficient weight loss diet program for vegan and vegeterians", attributes: [NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: customFont!)]))
        label.attributedText = attributedText
        
        return label
    }()
    
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.customFont(name: "Helvetica", size: 12)])
        attributedText.append(NSAttributedString(string: "Vegan, Vegeterian, dont tell me natthhinnn adasdasld kasşdkasşl asdlka slşdkşas lkd", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 12)]))
        label.attributedText = attributedText
        return label
    }()
    
    
    lazy var buttonStack = UIStackView(arrangedSubviews: [likeButton,likesLabel,UIView(), subscribeButton])
    
    private let line = UnderLineView()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        let vv = UIView()
        addSubview(vv)
        vv.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        vv.layer.shadowOpacity = 0.5
        vv.layer.shadowRadius = 2
        vv.layer.cornerRadius = 10
        vv.backgroundColor = .white
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, paddingTop: 6,paddingLeft: 12,paddingBottom: 20, paddingRight: 12)
        let ddiv = UIView()
        ddiv.addSubview(dietDefinitiveImage)
        dietDefinitiveImage.fillSuperview()
        ddiv.setupShadow(opacity: 1, radius: 2, offset: CGSize(width: 0, height: 1), color: #colorLiteral(red: 0.4060913706, green: 0.4060913706, blue: 0.4060913706, alpha: 1))
        vv.addSubview(ddiv)
        dietDefinitiveImage.layer.cornerRadius = 6
        dietDefinitiveImage.anchor(top: vv.topAnchor,left: vv.leftAnchor, bottom: vv.bottomAnchor,right: vv.centerXAnchor ,paddingTop: 50 + 11, paddingLeft: 12,paddingBottom: 110 - 50 + 4  , paddingRight: -15)
        
        
        
        let fiv = UIView()
        fiv.addSubview(firstFoodImage)
        firstFoodImage.fillSuperview()
        fiv.setupShadow(opacity: 1, radius: 2, offset: CGSize(width: 1, height: 0), color: #colorLiteral(red: 0.4060913706, green: 0.4060913706, blue: 0.4060913706, alpha: 1))
        let sfv = UIView()
        sfv.addSubview(secondFoodImage)
        secondFoodImage.fillSuperview()
        sfv.setupShadow(opacity: 1, radius: 2, offset: CGSize(width: 1, height: 0), color: #colorLiteral(red: 0.4060913706, green: 0.4060913706, blue: 0.4060913706, alpha: 1))
        
        let firstStack = UIStackView(arrangedSubviews: [fiv, sfv])
        
        
        
        firstFoodImage.layer.cornerRadius = 4
        secondFoodImage.layer.cornerRadius = 4
        firstStack.axis = .vertical
        firstStack.spacing = 6
        firstStack.distribution = .fillEqually
        firstStack.backgroundColor = .white
        vv.addSubview(firstStack)
        firstStack.anchor(top: dietDefinitiveImage.topAnchor, left: dietDefinitiveImage.rightAnchor,bottom: dietDefinitiveImage.bottomAnchor, right: vv.rightAnchor, paddingLeft: 6,paddingBottom: 0,paddingRight: 12)
        
        vv.addSubview(userProfileImage)
        //        userProfileImage.addSubview(defImage)
        //        defImage.fillSuperview()
        userProfileImage.layer.cornerRadius = 5
        userProfileImage.anchor(top: vv.topAnchor,left: dietDefinitiveImage.leftAnchor,bottom: dietDefinitiveImage.topAnchor ,paddingTop: 12,paddingLeft: 0, paddingBottom: 6)
        userProfileImage.setDimensions(height: 40, width: 40)
        
        
        
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, professionButton])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = -3
        addSubview(stack)
        stack.anchor(top: userProfileImage.topAnchor,left: userProfileImage.rightAnchor,bottom: userProfileImage.bottomAnchor,right: vv.rightAnchor ,paddingLeft: 8,paddingRight: 30, height: 35)
        stack.centerY(inView: userProfileImage)
        
        
        buttonStack.distribution = .equalCentering
        buttonStack.axis = .horizontal
        addSubview(buttonStack)
        buttonStack.anchor(bottom: userProfileImage.bottomAnchor,right: vv.rightAnchor, paddingBottom: 0, paddingRight: 15, width: 95, height: 30)
        
        
        
        let newerStack = UIStackView(arrangedSubviews: [titleLabel])
        newerStack.axis = .vertical
        newerStack.distribution = .equalCentering
        addSubview(newerStack)
        newerStack.anchor(top: dietDefinitiveImage.bottomAnchor,left: userProfileImage.leftAnchor, right: vv.rightAnchor ,paddingTop: 8,paddingRight: 60, height: 35)
        
        addSubview(savePostButton)
        savePostButton.anchor(left: newerStack.rightAnchor, right: vv.rightAnchor, paddingLeft: 10, paddingRight: 20, height: 30)
        savePostButton.centerY(inView: newerStack)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUsernameTapped() {
        //        delegate?.handleUsernameTapped(self)
    }
    
    
    @objc func handleLikeTapped(){
        //        delegate?.handleLikeTapped(self)
        
    }
    
    @objc func handleSubscribe() {
        //        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
        //        delegate?.handleShowLikes(for: self)
    }
    
    func configure() {
        guard let diet = diet else { return }
        guard let ownerId = diet.ownerId else { return }
        Service.fetchUser(withUid: ownerId) { (owner) in
            self.userNameLabel.setTitle(owner.name, for: .normal)
            self.professionButton.setTitle(owner.professionType, for: .normal)
            
            
            guard let profileImageUrl = owner.profileImageUrl else { return }
            if profileImageUrl == "" {
                self.defImage.isHidden = false
                
            } else {
                self.defImage.isHidden = true
                let unnecessaryUrling = URL(string: profileImageUrl)
                self.userProfileImage.sd_setImage(with: unnecessaryUrling)
            }
        }
        
        
        guard let mainImageUrl = diet.dietDefinitiveImageUrl else { return }
        let cmonUrl = URL(string: mainImageUrl)
        self.dietDefinitiveImage.sd_setImage(with: cmonUrl)
        
        titleLabel.text = diet.dietTitle
        
        
        
        
        Service.fetchUserStats(uid: ownerId) { (stats) in
            let attributedText = NSAttributedString(string: "Followers: \(stats.followers)",
                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])

            
        }
        
    }
}
