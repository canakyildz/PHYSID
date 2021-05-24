//
//  ContentView.swift
//  PHYSID
//
//  Created by Apple on 20.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol FeedContentDismissalDelegateForExplore: class {
    func dismissal()
}

private let reuseIdentifier = "FeedContentCell"
private let headerIdentifier = "FeedContentHeader"


class FeedContentController: UIViewController {
    
    
    // MARK: - Properties
    
    var comments = [Comment]() {
        didSet { collectionView.reloadData() }
    }
    lazy var headerView = FeedContentHeader()
    var post: Post!
    weak var delegate: FeedContentDismissalDelegateForExplore?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height ?? 80) * 2, width: view.frame.width, height: view.frame.height - 110)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.9668067893, green: 0.9668067893, blue: 0.9668067893, alpha: 1)
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedContentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(FeedContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9668067893, green: 0.9668067893, blue: 0.9668067893, alpha: 1)
        
        configureTableView()
        configureUI()
        checkIfUserLikedPosts()
        fetchComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = false
        let iv = UIImageView(image: #imageLiteral(resourceName: "navigationbarlogo"))
        iv.contentMode = .scaleAspectFit
        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor:#colorLiteral(red: 0.9668861041, green: 0.9668861041, blue: 0.9668861041, alpha: 1), titleColor: .white, prefersLargeTitles: false)
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        collectionView.reloadData()
    }
    
   
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true) {
            self.delegate?.dismissal()
        }
    }
    
    
    // MARK: - API
    
    func fetchComments() {
        guard let post = post else { return }
        Service.fetchComments(postId: post.postID) { (comments) in
            self.comments = comments
        }
    }
    
    func checkIfUserLikedPosts() {
        guard let post = self.post else { return }
        Service.checkIfUserLikedPost(post) { didLike in
            self.post.didLike = didLike
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureTableView() {
        view.addSubview(collectionView)
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
    
    func size(forWidth width: CGFloat, comment: Comment) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = comment.commentText
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
    func sizeOfImagery(forWidth width: CGFloat, post: Post) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.title
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedContentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var commentHeight: CGFloat = 70
        let comment = comments[indexPath.row]
        commentHeight = self.size(forWidth: view.frame.width - 50, comment: comment).height / 1.7
        
        return CGSize(width: view.frame.width - 40, height: commentHeight + 50)
    }
    
}

// MARK: - UICollectionViewDelegate

extension FeedContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FeedContentHeader
        header.post = self.post
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedContentController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let post = self.post
        
        var customHeight: CGFloat = 0
        let width = view.frame.width - 30
        
        if post!.isSay == true {
            
            customHeight = self.size(forWidth: width, post: post!).height / 1.6 + 115
            
        } else {
            
            customHeight = width + 80 + self.sizeOfImagery(forWidth: width, post: post!).height / 1.7 + self.size(forWidth: width, post: post!).height / 1.7
            
        }
        
        return CGSize(width: width, height: customHeight + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
    }
    
}


// MARK: - FeedContentHeaderDelegate

extension FeedContentController: FeedContentHeaderDelegate {
    
    func handleOptionsTapped(_ cell: FeedContentHeader) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleReloadingThroughCommenting(_ cell: FeedContentHeader, message: String) {
        guard let post = post else { return }
        let credentials = CommentCredentials.init(commentText: message)
        Service.uploadComment(credentials: credentials, post: post) { (err, ref) in
            self.collectionView.reloadData()
            
        }
    }
    
    
    func handleUsernameTapped(_ cell: FeedContentHeader) {
        guard let post = post else { return }
        let controller = ProfileController()
        controller.user = post.user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func handleLikeTapped(_ cell: FeedContentHeader) {
        guard let post = cell.post else { return }
        Service.likePost(post: post) { (err, ref) in
            cell.post?.didLike.toggle()
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.likes = likes
        }
    }
}
