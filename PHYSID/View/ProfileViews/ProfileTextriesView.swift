//
//  ProfileTextriesView.swift
//  PHYSID
//
//  Created by Apple on 19.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileTextriesViewDelegate: class {
    func handleShowTextryPost(_ nav: UINavigationController)
}


private let reuseIdentifier = "ProfileTextryCell"

class ProfileTextriesView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileTextriesViewDelegate?
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    private var user: User?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false //???
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(ProfileTextryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "Textry Contents"
        label.font = UIFont.customFont(name: "Helvetica Bold", size: 19)
        label.textColor = .black
        return label
    }()
    
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
            self.posts = posts.filter({ $0.isSay == true})
            self.checkIfUserLikedPosts()
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            Service.checkIfUserLikedPost(post) { didLike in
                guard didLike == true else { return }
                
                if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                    self.posts[index].didLike = true
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    
    func configureUI() {
        addSubview(postsLabel)
        postsLabel.anchor(top: topAnchor,paddingTop: 8, paddingLeft: 20, height: 20)
        postsLabel.centerX(inView: self)
        
        addSubview(collectionView)
        collectionView.anchor(top: postsLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 10, paddingRight: -4)
        
    }
    
    func size(forWidth width: CGFloat, post: Post) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileTextriesView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("countery says i am \(posts.count)")
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileTextryCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension ProfileTextriesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        var customHeight: CGFloat = 0
        let width = frame.width - 30
        
        if post.isSay == true {
            
            customHeight = self.size(forWidth: width, post: post).height + 120
            
        }
        return CGSize(width: width, height: customHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedContentController()
        controller.post = posts[indexPath.row]
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        delegate?.handleShowTextryPost(nav)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}


extension ProfileTextriesView: ProfileTextryCellDelegate {
    func handleUsernameTapped(_ cell: ProfileTextryCell) {
        print("")
    }
    
    func handleLikeTapped(_ cell: ProfileTextryCell) {
        guard let post = cell.post else { return }
        Service.likePost(post: post) { (err, ref) in
            cell.post?.didLike.toggle()
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.likes = likes
        }
    }
}
