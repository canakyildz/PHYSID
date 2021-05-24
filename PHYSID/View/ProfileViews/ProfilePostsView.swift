//
//  ProfilePostsView.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol ProfilePostsViewDelegate: class {
    func handleShowPost(_ nav: UINavigationController)
}


private let reuseIdentifier = "ProfilePostsCell"

class ProfilePostsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfilePostsViewDelegate?
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    private var user: User? 
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 250)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfilePostsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "Imagery Contents"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 19)
        label.textColor = .black
        return label
    }()
    
    var bioHeight: CGFloat?
    
    // MARK: - Lifecycle
    
    init(user: User,frame : CGRect) {
        self.user = user
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
        fetchPosts()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    func fetchPosts() {
        
        guard let user = user else { return }
        Service.fetchPosts(forUser: user) { (posts) in
            self.posts = posts.filter({ $0.isSay == false})
        }
    }
    
    // MARK: - Helpers
    
    
    func configureUI() {
        guard let user = user else { return }
        let secondaryNowSush = size(forWidth: frame.width - 10, user: user).height
        if secondaryNowSush < 21 {
            bioHeight = -65

        } else if secondaryNowSush > 21 && secondaryNowSush < 41 {
            bioHeight = -45
            
            
        } else if secondaryNowSush > 40 && secondaryNowSush < 62 {
            bioHeight = -35
            
        } else if secondaryNowSush > 62 && secondaryNowSush < 82 {
            bioHeight = -15
            
        }
        
        addSubview(postsLabel)
        postsLabel.anchor(top: topAnchor, paddingTop: bioHeight ?? 10, paddingLeft: 17, height: 22)
        postsLabel.centerX(inView: self)
        
        addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.anchor(top: postsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 11, paddingLeft: 10, height: 205)
        
    }
    
    
    func size(forWidth width: CGFloat, user: User) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = user.bio
        measurementLabel.numberOfLines = 4
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfilePostsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfilePostsCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

extension ProfilePostsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2.5 + 5, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedContentController()
        controller.post = posts[indexPath.row]
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        delegate?.handleShowPost(nav)
        
    }
    
}
