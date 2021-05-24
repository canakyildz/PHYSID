//
//  ExploreController.swift
//  PHYSID
//
//  Created by Apple on 18.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let collectionIdentifier = "ExploreCell"

protocol reloadAfterDismissingContent: class {
    func reloadAfterDismissingContent()
}

class ExploreController: UIViewController {
    
    // MARK: - Properties
    
    var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    weak var delegate: reloadAfterDismissingContent?
    
    lazy var collectionView: UICollectionView = {
        let layout = ExploreLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.dataSource = self
        layout.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false //???
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        cv.register(ExploreCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        return cv
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-exit-48").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9371530414, green: 0.9373135567, blue: 0.9371429086, alpha: 1)
        button.setDimensions(height: 26, width: 26)
        let label = UILabel()
        label.text = "Log out"
        label.textColor = #colorLiteral(red: 0.9371530414, green: 0.9373135567, blue: 0.9371429086, alpha: 1)
        button.addSubview(label)
        label.anchor(top: button.bottomAnchor, paddingBottom: 10)
        label.centerX(inView: button)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-settings-100").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9371530414, green: 0.9373135567, blue: 0.9371429086, alpha: 1)
        button.setDimensions(height: 24, width: 24)
        let label = UILabel()
        label.text = "Settings"
        label.textColor = #colorLiteral(red: 0.9371530414, green: 0.9373135567, blue: 0.9371429086, alpha: 1)
        button.addSubview(label)
        label.anchor(top: button.bottomAnchor, paddingBottom: 11.5)
        label.centerX(inView: button)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        return button
    }()
    
    
    let footerView: UIView = {
        let vv = UIView()
        vv.backgroundColor = .black
        vv.layer.shadowOpacity = 0.4
        vv.layer.shadowRadius = 1
        vv.layer.shadowColor = UIColor.black.cgColor
        vv.layer.shadowOffset = CGSize(width: 0, height: -0.4)
        return vv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        DispatchQueue.main.async {
            self.configureUI()

        }
        
        DispatchQueue.global().async {
            self.fetchPosts()

        }
        
        
        
    }
    
    // MARK: - API
    
    func fetchPosts() {
        Service.fetchPosts { (posts) in
            self.posts = posts.sorted(by: { (post1, post2) -> Bool in
                return post1.likes > post2.likes
                
            })
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func showMainUI() {
        dismiss(animated: true, completion: nil)
        
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
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.setDimensions(height: 26, width: 26)
        button.addTarget(self, action: #selector(showMainUI), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor,paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: view.frame.height)
        
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

extension ExploreController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("now telll me \(posts.count)")
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! ExploreCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedContentController()
        controller.delegate = self
        controller.post = posts[indexPath.row]
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - ExploreLayoutDelegate


extension ExploreController: ExploreLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        
        var limitWidth: CGFloat = 0
        var limitHeight: CGFloat = 0
        
        
        if view.frame.width < 390 {
            limitWidth = view.frame.width / 2.2
        } else {
            limitWidth = view.frame.width / 2.17
        }
        
        if post.isSay == true {
            
            limitHeight = self.size(forWidth: limitWidth - 10 , post: post).height + 10
            
        } else {
            
            limitHeight = view.frame.width < 390 ? 220 : 225
        }
        
        return limitHeight
    }
    
    
}

extension ExploreController: FeedContentDismissalDelegateForExplore {
    func dismissal() {
        delegate?.reloadAfterDismissingContent()
    }
    
    
}






