//
//  ProfilePostsCell.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class ProfilePostsCell: UICollectionViewCell {
    
    // MARK: - Properties
        
    var post: Post? {
        didSet { configure() }
    }
    
    let postsView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Men's GYM Fitness Clothing simple"))
        iv.backgroundColor =  .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "New day new things, you know the vibes!!!!! Don't you play with the gang cuuuz"
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 11)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
     private lazy var imageryVV = UIView()
    
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
        backgroundColor = .white
        
        let mv = UIView()
        addSubview(mv)
        mv.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 4,paddingLeft: 4, paddingBottom: 4)
        mv.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        mv.layer.shadowOpacity = 0.4
        mv.layer.shadowColor = UIColor.black.cgColor
        mv.layer.cornerRadius = 7
        mv.backgroundColor = .clear
        
        mv.addSubview(postsView)
        postsView.layer.cornerRadius = 7
        postsView.anchor(top: mv.topAnchor, left: mv.leftAnchor, bottom: mv.bottomAnchor, right: mv.rightAnchor, paddingBottom: 30)
        
        
        
        addSubview(captionLabel)
        bringSubviewToFront(captionLabel)
        captionLabel.anchor(top: postsView.bottomAnchor, left: postsView.leftAnchor,bottom: bottomAnchor, right: postsView.rightAnchor,paddingTop: 3, paddingLeft: 5,paddingRight: 3)
        
    }
    
    func configure() {
        guard let post = post else { return }
        guard let postImageUrl = post.postImageUrl else { return }
        postsView.sd_setImage(with: URL(string: postImageUrl))
        captionLabel.text = post.title
        
    }
    
}
