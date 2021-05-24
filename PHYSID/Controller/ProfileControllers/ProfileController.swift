//
//  ProfileController.swift
//  PHYSID
//
//  Created by Apple on 16.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeaderView"

class ProfileController: UIViewController {
    
    // MARK: - Properties
    
    var user: User!
    var collectionView: UICollectionView!
    private lazy var progressButton: UIButton = {
        let button = UIButton()
        let iv = UIImageView(image: #imageLiteral(resourceName: "your-process").withTintColor(.white))
        button.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        button.addSubview(iv)
        iv.setDimensions(height: 30, width: 30)
        return button
    }()
    
    private lazy var leftBarButton: UIButton = {
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = .white
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleDis), for: .touchUpInside)
        return leftButton
    }()
    
    private let scrollView = UIScrollView()
    private let fourthLine = UnderLineView()
    private var bioHeight: CGFloat?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user == nil {
            fetchCurrentUser()
            navigationController?.isNavigationBarHidden = true
        } else {
            
            navigationController?.isNavigationBarHidden = false
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
            configureNavigationBar(withTitle: "", titleView: nil, backgroundcolor: .clear, titleColor: .white, prefersLargeTitles: false)
        }
        
        configureCollectionView()
        configureUI()
        checkIfUserIsFollowed()
        fetchUserStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleDis() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        view.bringSubviewToFront(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
    
    // MARK: - API
    
    func checkIfUserIsFollowed() {
        if self.user == nil {
        } else {
            Service.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                self.user.isFollowed = isFollowed
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchUserStats() {
        if self.user == nil {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            Service.fetchUserStats(uid: currentUid) { stats in
                self.user.stats = stats
                self.collectionView.reloadData()
            }
            
        } else {
            Service.fetchUserStats(uid: user.uid) { (stats) in
                self.user.stats = stats
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchCurrentUser() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUid: currentUid) { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    
    
    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        let yValue: CGFloat = self.user == nil ? -45 : -90
        let frame = CGRect(x: 0, y: yValue, width: view.frame.width, height: 590 + ((navigationController?.navigationBar.frame.height)!))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        scrollView.addSubview(collectionView)
        scrollView.bringSubviewToFront(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let frame2 = CGRect(x: 0, y: collectionView.frame.height + yValue, width: view.frame.width, height: 220)
        
        if self.user == nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Service.fetchUser(withUid: uid) { (user) in
                
                let secondaryNowSush = self.size(forWidth: frame.width - 10, user: user).height
                if secondaryNowSush < 21 {
                    self.bioHeight = -65
                    
                } else if secondaryNowSush > 21 && secondaryNowSush < 41 {
                    self.bioHeight = -45
                    
                    
                } else if secondaryNowSush > 40 && secondaryNowSush < 62 {
                    self.bioHeight = -35
                    
                } else if secondaryNowSush > 62 && secondaryNowSush < 82 {
                    self.bioHeight = -15
                    
                }
                
                
                Service.fetchPosts(forUser: user) { (posts) in
                    let postCount = posts.filter({ $0.isSay == true }).count
                    var differentialHeight: CGFloat = 0
                    if postCount == 0 {
                        differentialHeight = 0
                    } else if postCount == 1 {
                        differentialHeight = 300
                    } else if postCount >= 2 {
                        differentialHeight = 800
                    }
                    
                    print("asdsa \(self.view.frame.height )")
                    
                    if self.view.frame.height < 800 {
                        differentialHeight += 200
                    }
                    
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + differentialHeight)
                    
                    let postsView = ProfilePostsView(user: user, frame: frame2)
                    let textryView = ProfileTextriesView(user: user, frame: .zero)
                    textryView.delegate = self
                    postsView.delegate = self
                    self.scrollView.addSubview(postsView)
                    self.scrollView.addSubview(textryView)
                    
                    
                    textryView.anchor(top: postsView.bottomAnchor, left: postsView.leftAnchor, right: postsView.rightAnchor,paddingTop: (self.bioHeight ?? 0) + 30,paddingRight: 10, height: differentialHeight)
                }
            }
            
        } else {
            
            let secondaryNowSush = self.size(forWidth: frame.width - 10, user: self.user).height
            if secondaryNowSush < 21 {
                self.bioHeight = -65
                
            } else if secondaryNowSush > 21 && secondaryNowSush < 41 {
                self.bioHeight = -45
                
                
            } else if secondaryNowSush > 40 && secondaryNowSush < 62 {
                self.bioHeight = -35
                
            } else if secondaryNowSush > 62 && secondaryNowSush < 82 {
                self.bioHeight = -15
            }
            
            Service.fetchPosts(forUser: user) { (posts) in
                let postCount = posts.filter({ $0.isSay == true }).count
                var differentialHeight: CGFloat = 0
                if postCount == 0 {
                    differentialHeight = 0
                } else if postCount == 1 {
                    differentialHeight = 300
                } else if postCount >= 2 {
                    differentialHeight = 800
                }
                
                if self.view.frame.height < 800 {
                    differentialHeight += 300
                }
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + differentialHeight - 100)
                
                let postsView = ProfilePostsView(user: self.user, frame: frame2)
                let textryView = ProfileTextriesView(user: self.user, frame: .zero)
                textryView.delegate = self
                postsView.delegate = self
                self.scrollView.addSubview(postsView)
                self.scrollView.addSubview(textryView)
                
                
                textryView.anchor(top: postsView.bottomAnchor, left: postsView.leftAnchor, right: postsView.rightAnchor,paddingTop: (self.bioHeight ?? 0) + 20,paddingLeft: -7, paddingRight: 10, height: differentialHeight)
            }
        }
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

// MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeaderView
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 600 + ((navigationController?.navigationBar.frame.height)!))
    }
}

// MARK: - ProfileHeaderViewDelegate

extension ProfileController: ProfileHeaderViewDelegate {
    func startChatting(_ header: ProfileHeaderView, wantsToChatwith user: User) {
        let controller = ChatController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    func follow(_ header: ProfileHeaderView) {
        if user.isFollowed {
            Service.unfollowUser(uid: user.uid) { (err, ref) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                self.fetchUserStats()
            }
            
        } else {
            Service.followUser(uid: user.uid) { (ref, err) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                self.fetchUserStats()
            }
        }
    }
    
    func handleShowEditProfile() {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
}

// MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        Service.saveUserData(user: user) { (err, ref) in
            self.fetchCurrentUser()
            controller.dismiss(animated: true) {
                self.user = user
                self.collectionView.reloadData()
            }
        }
    }
}


extension ProfileController: ProfileTextriesViewDelegate {
    func handleShowTextryPost(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
    }
    
    
}

extension ProfileController: ProfilePostsViewDelegate {
    func handleShowPost(_ nav: UINavigationController) {
        present(nav, animated: true, completion: nil)
        
    }
    
    
}


