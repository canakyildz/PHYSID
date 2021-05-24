//
//  FeedContentCell.swift
//  PHYSID
//
//  Created by Apple on 20.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

class FeedContentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet { configure() }
        
    }
    let commentTextView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.customFont(name: "Helvetica", size: 14)
        tv.numberOfLines = 0
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    func getCommentTimeStamp() -> String? {
        
        guard let comment = self.comment else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1 //this is gonna make it 1h 1w 1m 1s..
        dateFormatter.unitsStyle = .abbreviated // kısaltma
        let now = Date()
        return dateFormatter.string(from: comment.creationDate, to: now)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        layer.shadowOffset = CGSize(width: 0.1, height: 0.3)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
       
        profileImageView.layer.cornerRadius = 8
        
        let vv = UIView()
        vv.backgroundColor = .white
        addSubview(vv)
        vv.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        vv.layer.cornerRadius = 7

        
        addSubview(commentTextView)
        commentTextView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        commentTextView.layer.cornerRadius = 7
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        guard let comment = self.comment else { return }
        guard let user = comment.user else { return }
        guard let username = user.name else { return }
        guard let commentText = comment.commentText else { return }
        guard let timestamp = getCommentTimeStamp() else { return }
        guard let url = user.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: url))
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Bold", size: 14)])
        attributedText.append(NSAttributedString(string: " \(commentText)", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica", size: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestamp). ", attributes: [NSAttributedString.Key.font: UIFont.customFont(name: "Helvetica Light", size: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        commentTextView.attributedText = attributedText
    
    
 }
}
