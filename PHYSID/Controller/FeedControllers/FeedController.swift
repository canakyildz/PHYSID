//
//  FeedController.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let collectionIdentifier = "FeedCell"

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User!
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false //???
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = #colorLiteral(red: 0.9668067893, green: 0.9668067893, blue: 0.9668067893, alpha: 1)
        cv.register(FeedCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        return cv
    }()
    
    
    var showMenu = false
    private var definitiveSharePostView = NewPostDefinitiveView()
    
    private lazy var sharePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
        return button
    }()
    private lazy var messagesButton: UIButton = {
        let button = UIButton()
        let iv = UIImageView(image: #imageLiteral(resourceName: "inboxactaully").withTintColor(.white))
        button.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        button.addSubview(iv)
        iv.setDimensions(height: 30, width: 32)
        button.addTarget(self, action: #selector(showTrainersController), for: .touchUpInside)
        return button
    }()
    
    private lazy var expanderButton: UIButton = {
        let button = UIButton()
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-menu-50").withTintColor(.white))
        button.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        button.addSubview(iv)
        iv.setDimensions(height: 34, width: 25.5)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PHYSID"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9668067893, green: 0.9668067893, blue: 0.9668067893, alpha: 1)
        DispatchQueue.global().async {
            self.fetchUser()
            self.fetchPosts()
        }
        DispatchQueue.main.async {
            self.configureNav()
            self.configureFilteringView()
            self.configureCollectionView()
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSharePost() {
        let controller = NewPostDefinitiveView()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func handleShowExplore() {
        let controller = ExploreController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    @objc func showTrainersController() {
        guard let user = self.user else { return }
        let controller = MessageController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
        }
    }
    
    func fetchPosts() {
        
        Service.fetchPosts { (posts) in
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
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
    
    func configureFilteringView() {
        view.addSubview(sharePostButton)
        view.bringSubviewToFront(sharePostButton)
        sharePostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30, paddingRight: 30, width: 52, height: 52)
    }
    
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 10,height: view.frame.height - 120)
    }
    
    
    func configureNav() {
        let iv = UIImageView(image: #imageLiteral(resourceName: " PHYSID.").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 25, width: 50)
        
        
        configureNavigationBar(withTitle: "", titleView: iv, backgroundcolor: .black, titleColor: .white, prefersLargeTitles: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: expanderButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messagesButton)
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
    
    
    
    func sizeOfImagery(forWidth width: CGFloat, post: Post) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.title
        measurementLabel.numberOfLines = 2
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FeedController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedContentController()
        controller.post = posts[indexPath.row]
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        
        var customHeight: CGFloat = 0
        let width = view.frame.width - 30
        
        if post.isSay == true {
            
            customHeight = self.size(forWidth: width, post: post).height + 115
            
        } else {
            
            customHeight = width + 50 + self.sizeOfImagery(forWidth: width, post: post).height
            
        }
        
        return CGSize(width: width, height: customHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}


// MARK: - NewPostControllerDelegate

extension FeedController: NewPostControllerDelegate {
    func reloadThroughDismissal() {
        self.collectionView.reloadData()
    }
    
    
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func handleLikeTapped(_ cell: FeedCell) {
        guard let post = cell.post else { return }
        Service.likePost(post: post) { (err, ref) in
            cell.post?.didLike.toggle()
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.likes = likes
        }
        
    }
    
    func handleUsernameTapped(_ cell: FeedCell) {
        guard let post = cell.post else { return }
        let controller = ProfileController()
        controller.user = post.user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}




