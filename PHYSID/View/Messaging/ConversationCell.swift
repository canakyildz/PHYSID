//
//  ConversationCell.swift
//  Tinder
//
//  Created by Apple on 10.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit


class ConversationCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        return iv
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Can Akyıldız"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Hey girlll"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        profileImage.anchor(left: leftAnchor, paddingLeft: 12)
        profileImage.setDimensions(height: 50, width: 50)
        profileImage.layer.cornerRadius = 50 / 2
        profileImage.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImage)
        stack.anchor(left: profileImage.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor,right: rightAnchor,paddingTop: 20,paddingRight: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)
        timestampLabel.text = viewModel.creationDate
        profileImage.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = conversation.user.name
        messageTextLabel.text = conversation.message.text
        
    }
    
}
